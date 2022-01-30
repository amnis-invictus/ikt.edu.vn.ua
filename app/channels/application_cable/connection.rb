module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :task

    def connect
      password, task_id = request.params.values_at :password, :task_id
      @task = Task.find_by id: task_id if password.present? && task_id.present?
      password_valid = ActiveSupport::SecurityUtils.secure_compare password, @task.contest.judge_password if @task
      reject_unauthorized_connection unless password_valid
    end
  end
end
