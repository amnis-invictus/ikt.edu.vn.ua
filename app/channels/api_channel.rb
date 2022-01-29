class ApiChannel < ApplicationCable::Channel
  def subscribed
    @task = Task.find params[:task]
    ensure_confirmation_sent
    dispatch 'app/start'
    dispatch 'users/load', @task.contest.users.order(:secret).pluck(:secret)
    transmit_criterions
    dispatch 'app/ready'
  rescue ActiveRecord::RecordNotFound
    reject
  end

  def add_criterion
    criterion = @task.criterions.create! position: @task.criterions_count
    dispatch 'criteria/add', criterion
  end

  def update_criterion data
    criterion = @task.criterions.find data['id']
    criterion.update! data['params']
    dispatch 'criteria/update', criterion
  end

  def delete_criterion data
    criterion = @task.criterions.find data['id']
    criterion.destroy!
    @task.criterions.where('position > ?', criterion.position).update_all('position = position - 1')
    dispatch 'criteria/delete', data['id']
  end

  def drag_drop data
    from, to = data.values_at 'from', 'to'

    subject = @task.criterions.find_by! position: from
    subject.update! position: to

    other_criterions = @task.criterions.where.not id: subject.id
    if from > to
      other_criterions.where('position BETWEEN ? AND ?', to, from).update_all('position = position + 1')
    else
      other_criterions.where('position BETWEEN ? AND ?', from, to).update_all('position = position - 1')
    end
  ensure
    transmit_criterions
  end

  private

  def transmit_criterions
    dispatch 'criteria/load', @task.criterions.order(:position)
  end

  def dispatch action, payload = nil
    transmit({ type: action, payload: })
  end
end
