class ApiChannel < ApplicationCable::Channel
  rescue_from(ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound) { dispatch_self 'errors/push', _1 }

  def subscribed
    ensure_confirmation_sent
    dispatch_self 'app/start'
    dispatch_self 'users/load', User.joins(contest: :tasks).where(tasks: { id: task_id }).order(:secret).pluck(:secret)
    dispatch_self 'criteria/load', task_criterions.order(:position)
    dispatch_self 'app/ready'
    stream_from task_id
  end

  def add_criterion
    criterion = task_criterions.create! position: task_criterions.count
    dispatch_all 'criteria/add', criterion
  end

  def update_criterion data
    criterion = task_criterions.find data['id']
    criterion.update! data['params']
    dispatch_all 'criteria/cleanUpdate', id: criterion.id, token: data['token'], value: criterion
  end

  def delete_criterion data
    criterion = task_criterions.find data['id']
    criterion.destroy!
    task_criterions.where('position > ?', criterion.position).update_all('position = position - 1')
    dispatch_all 'criteria/delete', data['id']
  end

  def drag_drop data
    from, to = data.values_at 'from', 'to'

    subject = task_criterions.find_by! position: from
    subject.update! position: to

    other_criterions = task_criterions.where.not id: subject.id
    if from > to
      other_criterions.where('position BETWEEN ? AND ?', to, from).update_all('position = position + 1')
    else
      other_criterions.where('position BETWEEN ? AND ?', from, to).update_all('position = position - 1')
    end
  ensure
    dispatch_all 'criteria/loadPosition', task_criterions.order(:position).pluck(:id, :position).to_h
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
end
