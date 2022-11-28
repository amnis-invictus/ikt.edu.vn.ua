module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :task_id, :client_id

    def connect
      token, password, @task_id, @client_id = request.params.values_at :token, :password, :task_id, :client_id

      auth_valid = false
      if token.present?
        auth_valid = Rails.application.message_verifier(:scoring).verified(token) == @task_id
      elsif password.present?
        task = Task.find_by id: @task_id if @task_id.present?
        auth_valid = ActiveSupport::SecurityUtils.secure_compare password, task.contest.judge_password if task
      end

      reject_unauthorized_connection unless auth_valid
    end

    def disconnect
      RedisLockManager.release_all client_id
      ActionCable.server.broadcast task_id, { type: 'locks/load', payload: RedisLockManager.all }
    end
  end
end
