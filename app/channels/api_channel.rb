class ApiChannel < ApplicationCable::Channel
  rescue_from(StandardError) { dispatch_self 'errors/push', _1 }

  def subscribed
    ensure_confirmation_sent
    dispatch_self 'app/start'
    dispatch_self 'users/load', task_users.order(:judge_secret).pluck(:judge_secret)
    dispatch_self 'criteria/load', task_criterions.order(:position)
    dispatch_self 'results/load', CriterionUserResult.includes(:user).where(criterion: task_criterions)
    dispatch_self 'comments/load', Comment.includes(:user).where(task_id:)
    dispatch_self 'locks/load', RedisLockManager.all
    dispatch_self 'app/ready', ready_info
    stream_from task_id
  end

  def add_criterion
    unless Task.find(task_id).scoring_open
      dispatch_self 'errors/push', 'Add criterion failed: Scoring is closed'
      return
    end

    criterion = task_criterions.create! position: task_criterions.count
    dispatch_all 'criteria/add', criterion
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def update_criterion data
    unless Task.find(task_id).scoring_open
      dispatch_self 'errors/push', 'Update criterion failed: Scoring is closed'
      return
    end

    criterion = task_criterions.find data['id']
    criterion.update! data['params']
    dispatch_all 'criteria/cleanUpdate', id: criterion.id, token: data['token'], value: criterion
  end

  def delete_criterion data
    unless Task.find(task_id).scoring_open
      dispatch_self 'errors/push', 'Delete criterion failed: Scoring is closed'
      return
    end

    criterion = task_criterions.find data['id']
    criterion.destroy!
    task_criterions.where('position > ?', criterion.position).update_all('position = position - 1')
    dispatch_all 'criteria/delete', data['id']
  end

  def drag_drop data
    unless Task.find(task_id).scoring_open
      dispatch_self 'errors/push', 'Change criterions order failed: Scoring is closed'
      return
    end
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
    unless Task.find(task_id).scoring_open
      dispatch_self 'errors/push', 'Write result failed: Scoring is closed'
      return
    end

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
    unless Task.find(task_id).scoring_open
      dispatch_self 'errors/push', 'Reset result failed: Scoring is closed'
      return
    end

    user = task_users.find_by! judge_secret: data['user']
    criterion = task_criterions.find data['criterion']
    dispatch_self 'results/reset', CriterionUserResult.create_or_find_by!(user:, criterion:)
  end

  def write_comment data
    unless Task.find(task_id).scoring_open
      dispatch_self 'errors/push', 'Write comment failed: Scoring is closed'
      return
    end

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
    unless Task.find(task_id).scoring_open
      dispatch_self 'errors/push', 'Reset comment failed: Scoring is closed'
      return
    end

    user = task_users.find_by! judge_secret: data['user']
    dispatch_self 'comments/reset', Comment.create_or_find_by!(user:, task_id:)
  end

  def zero_results data
    unless Task.find(task_id).scoring_open
      dispatch_self 'errors/push', 'Zero result failed: Scoring is closed'
      return
    end

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

  def finish
    task = Task.find task_id
    unless task.scoring_open
      dispatch_self 'errors/push', 'Finish failed: Scoring is closed'
      return
    end

    ActiveRecord::Base.transaction do
      task.update! scoring_open: false

      task.contest.users.find_each do |u|
        score = CriterionUserResult.where(user: u, criterion: task.criterions).sum(:value)
        Result.create_or_find_by!(user: u, task:).update!(score:)
      end
    end
  rescue StandardError => e
    dispatch_self 'errors/push', "Finish failed: #{e}"
  else
    dispatch_all 'app/finish'
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
    User.joins(contest: :tasks).where(tasks: { id: task_id })
  end

  def ready_info
    task = Task.find task_id
    { contest_name: task.contest.display_name, task_name: task.display_name, read_only: !task.scoring_open }
  end
end
