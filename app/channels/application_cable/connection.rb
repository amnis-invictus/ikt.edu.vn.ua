module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :task_id, :client_id

    def connect
      password, @task_id, @client_id = request.params.values_at :password, :task_id, :client_id
      task = Task.find_by id: @task_id if password.present? && @task_id.present?
      password_valid = ActiveSupport::SecurityUtils.secure_compare password, task.contest.judge_password if task
      reject_unauthorized_connection unless password_valid
    end

    def disconnect
      RedisLockManager.release_all client_id
      ActionCable.server.broadcast task_id, { type: 'locks/load', payload: RedisLockManager.all }
    end
  end
end
