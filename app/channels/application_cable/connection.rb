module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :task_id, :client_id

    def connect
      @task_id, @client_id = request.params.values_at :task_id, :client_id
      reject_unauthorized_connection unless task_valid && (token_valid || password_valid)
    end

    def disconnect
      RedisLockManager.release_all client_id
      ActionCable.server.broadcast task_id, { type: 'locks/load', payload: RedisLockManager.all }
    end

    private

    def task_valid
      @task = Task.find_by id: task_id if task_id.present?
      @task.present?
    end

    def token_valid
      token = request.params[:token]
      return false if token.blank?

      Rails.application.message_verifier(:scoring).verified(token) == task_id
    end

    def password_valid
      password = request.params[:password]
      return false if password.blank?

      ActiveSupport::SecurityUtils.secure_compare password, @task.contest.judge_password
    end
  end
end
