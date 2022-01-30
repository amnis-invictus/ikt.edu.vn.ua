class ApiChannel < ApplicationCable::Channel
  rescue_from(ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound) { dispatch_self 'errors/push', _1 }

  def subscribed
    ensure_confirmation_sent
    dispatch_self 'app/start'
    dispatch_self 'users/load', task.contest.users.order(:secret).pluck(:secret)
    dispatch_self 'criteria/load', task.criterions.order(:position)
    dispatch_self 'app/ready'
    stream_for task
  end

  def add_criterion
    criterion = task.criterions.create! position: task.criterions_count
    dispatch_all 'criteria/add', criterion
  end

  def update_criterion data
    criterion = task.criterions.find data['id']
    criterion.update! data['params']
    dispatch_all 'criteria/update', criterion
  end

  def delete_criterion data
    criterion = task.criterions.find data['id']
    criterion.destroy!
    task.criterions.where('position > ?', criterion.position).update_all('position = position - 1')
    dispatch_all 'criteria/delete', data['id']
  end

  def drag_drop data
    from, to = data.values_at 'from', 'to'

    subject = task.criterions.find_by! position: from
    subject.update! position: to

    other_criterions = task.criterions.where.not id: subject.id
    if from > to
      other_criterions.where('position BETWEEN ? AND ?', to, from).update_all('position = position + 1')
    else
      other_criterions.where('position BETWEEN ? AND ?', from, to).update_all('position = position - 1')
    end
  ensure
    dispatch_all 'criteria/load', task.criterions.order(:position)
  end

  private

  def dispatch_self action, payload = nil
    transmit({ type: action, payload: })
  end

  def dispatch_all action, payload = nil
    broadcast_to task, { type: action, payload: }
  end
end
