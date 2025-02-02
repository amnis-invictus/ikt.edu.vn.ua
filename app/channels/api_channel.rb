class ApiChannel < ApplicationCable::Channel
  rescue_from(StandardError) { dispatch_self 'errors/push', _1 }

  def subscribed
    ensure_confirmation_sent
    task = Task.find task_id
    dispatch_self 'app/start'
    dispatch_self 'users/load', task_users.order(:judge_secret).pluck(:judge_secret)
    dispatch_self 'criteria/load', task_criterions.order(:position)
    dispatch_self 'judges/load', task.judges
    dispatch_self 'resultMultiplier/load', task.result_multiplier
    dispatch_self 'results/load', CriterionUserResult.includes(:user).where(criterion: task_criterions)
    dispatch_self 'comments/load', Comment.includes(:user).where(task_id:)
    dispatch_self 'locks/load', RedisLockManager.all
    dispatch_self 'app/ready', ready_info
    stream_from task_id
  end

  def add_criterion data
    return unless scoring_open data

    criterion = task_criterions.create! position: task_criterions.count
    dispatch_all 'criteria/add', criterion
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def update_criterion data
    return unless scoring_open data

    criterion = task_criterions.find data['id']
    criterion.update! data['params']
    dispatch_all 'criteria/cleanUpdate', id: criterion.id, token: data['token'], value: criterion
  end

  def delete_criterion data
    return unless scoring_open data

    criterion = task_criterions.find data['id']
    criterion.destroy!
    task_criterions.where('position > ?', criterion.position).update_all('position = position - 1')
    dispatch_all 'criteria/delete', data['id']
  end

  def add_judge data
    return unless scoring_open data

    task = Task.find task_id
    task.judges << data['value']
    task.save!
    dispatch_all 'judges/load', task.judges
  end

  def delete_judge data
    return unless scoring_open data

    task = Task.find task_id
    if task.judges[data['index']] == data['value']
      task.judges.delete_at data['index']
      task.save!
      dispatch_all 'judges/load', task.judges
    else
      dispatch_self 'errors/push', "Delete failed: Judge #{data['index']} has changed"
    end
  end

  def write_result_multiplier data
    return unless scoring_open data

    task = Task.find task_id
    task.result_multiplier = data['value']
    task.save!
    dispatch_all 'resultMultiplier/load', task.result_multiplier
  end

  def drag_drop data
    return unless scoring_open data

    from, to = data.values_at 'from', 'to'
    if from > to
      task_criterions.where('position BETWEEN ? AND ?', to, from)
        .update_all(['position = (CASE WHEN position = ? THEN ? ELSE position + 1 END)', from, to])
    else
      task_criterions.where('position BETWEEN ? AND ?', from, to)
        .update_all(['position = (CASE WHEN position = ? THEN ? ELSE position - 1 END)', from, to])
    end
  ensure
    dispatch_all 'criteria/loadPosition', task_criterions.order(:position).pluck(:id, :position).to_h
  end

  def write_result data
    return unless scoring_open data

    lock = [task_id, data['user'], data['criterion']].join ':'
    performed = RedisLockManager.with_lock lock, client_id do
      user = task_users.find_by! judge_secret: data['user']
      criterion = task_criterions.find data['criterion']
      result = CriterionUserResult.create_or_find_by!(user:, criterion:)
      result.update! value: data['value']
      dispatch_all 'results/cleanUpdate', result.as_json.merge(token: data['token'])
    end
    dispatch_self 'errors/push', "Write failed: Lock #{lock} was acquired by someone else" unless performed
  end

  def reset_result data
    user = task_users.find_by! judge_secret: data['user']
    criterion = task_criterions.find data['criterion']
    dispatch_self 'results/reset', CriterionUserResult.create_or_find_by!(user:, criterion:)
  end

  def write_comment data
    return unless scoring_open data

    lock = [task_id, data['user'], 'comment'].join ':'
    performed = RedisLockManager.with_lock lock, client_id do
      user = task_users.find_by! judge_secret: data['user']
      comment = Comment.create_or_find_by!(user:, task_id:)
      comment.update! value: data['value']
      dispatch_all 'comments/cleanUpdate', comment.as_json.merge(token: data['token'])
    end
    dispatch_self 'errors/push', "Write failed: Lock #{lock} was acquired by someone else" unless performed
  end

  def reset_comment data
    user = task_users.find_by! judge_secret: data['user']
    dispatch_self 'comments/reset', Comment.create_or_find_by!(user:, task_id:)
  end

  def zero_results data
    return unless scoring_open data

    user = task_users.find_by! judge_secret: data['user']
    task_criterions.each do |criterion|
      lock = [task_id, data['user'], criterion.id].join ':'
      performed = RedisLockManager.with_lock lock, client_id do
        result = CriterionUserResult.create! user:, criterion:, value: 0
        dispatch_all 'results/cleanUpdate', result.as_json
      rescue ActiveRecord::RecordNotUnique # don't overwrite existing values
      end
      dispatch_self 'errors/push', "Zero failed: Lock #{lock} was acquired by someone else" unless performed
    end
  end

  def zero_no_solution data
    return unless scoring_open data

    task = Task.find task_id
    force_close_and_finish! task
    dispatch_self 'notifications/push', kind: 'info', message: 'Zeroing results for users without solutions …'

    users_without_any_solution = Set.new task_users.where.missing(:solutions).pluck(:id)
    begin
      ActiveRecord::Base.transaction do
        task_users.find_each do |user|
          next if user.solutions.exists?(task_id:)

          task.criterions.each { CriterionUserResult.create_or_find_by!(user:, criterion: _1).update!(value: 0) }
          comment = users_without_any_solution.include?(user.id) ? 'папка відсутня' : 'файл відсутній'
          Comment.create_or_find_by!(user:, task_id:).update!(value: comment)
        end
      end
    ensure
      reopen! task
    end
  end

  def finish data
    return unless scoring_open data

    task = Task.find task_id
    force_close_and_finish! task
    dispatch_self 'notifications/push', kind: 'info', message: 'Calculating results …'

    users_without_result = []
    begin
      result_multiplier = Rational task.result_multiplier

      ActiveRecord::Base.transaction do
        task_users.find_each do |user|
          user_result = CriterionUserResult.where user:, criterion: task.criterions
          users_without_result << user.judge_secret unless user_result.count == task.criterions_count
          score = user_result.sum(:value) * result_multiplier
          Result.create_or_find_by!(user:, task:).update!(score:)
        end

        raise "Users that missing some result: #{users_without_result.to_sentence}" unless users_without_result.empty?
      end
    rescue StandardError => e
      reopen! task
      raise e
    else
      dispatch_self 'notifications/push', kind: 'success', message: 'Results calculated'
    end
  end

  def acquire_lock data
    if RedisLockManager.acquire data['lock'], client_id
      dispatch_all 'locks/acquire', data.merge(client_id:)
    else
      dispatch_self 'errors/push', "Lock #{data['lock']} was acquired by someone else"
    end
  end

  def release_lock data
    if RedisLockManager.release data['lock'], client_id
      dispatch_all 'locks/release', data.merge(client_id:)
    else
      dispatch_self 'errors/push', "Lock #{data['lock']} was acquired by someone else"
    end
  end

  private

  def dispatch_self action, payload = nil
    transmit({ type: action, payload: })
  end

  def dispatch_all action, payload = nil
    ActionCable.server.broadcast task_id, { type: action, payload: }
  end

  def task_criterions
    Criterion.where task_id:
  end

  def task_users
    User.joins(contest: :tasks).where(tasks: { id: task_id }).attending
  end

  def ready_info
    task = Task.find task_id
    { contest_name: task.contest.display_name, task_name: task.display_name, read_only: !task.scoring_open }
  end

  def scoring_open data
    return true if Task.find(task_id).scoring_open

    dispatch_self 'errors/push', "#{data['action']} failed: Scoring is closed"
    false
  end

  def force_close_and_finish! task
    task.update_column :scoring_open, false
    RedisLockManager.release_all
    dispatch_all 'locks/load', RedisLockManager.all
    dispatch_all 'results/load', CriterionUserResult.includes(:user).where(criterion: task_criterions)
    dispatch_all 'comments/load', Comment.includes(:user).where(task_id:)
    dispatch_all 'app/finish'
  end

  def reopen! task
    task.update_column :scoring_open, true
    dispatch_all 'results/load', CriterionUserResult.includes(:user).where(criterion: task_criterions)
    dispatch_all 'comments/load', Comment.includes(:user).where(task_id:)
    dispatch_all 'app/ready', ready_info
  end
end
