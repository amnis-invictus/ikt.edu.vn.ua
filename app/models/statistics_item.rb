class StatisticsItem
  include ActiveModel::Model

  attr_accessor :user

  delegate :name, :contest, :solutions, to: :user, allow_nil: true

  delegate :tasks, to: :contest

  def records
    tasks.order(:id).map do |task|
      next 'no' if (solution = solutions.where(task: task).last).nil?

      "#{solution.upload_number} (#{solution.created_at.in_time_zone('Europe/Kiev').strftime('%Y-%m-%d %H:%M')})"
    end
  end
end
