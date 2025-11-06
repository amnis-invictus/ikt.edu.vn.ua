class AssignSleepServicesJob < ApplicationJob
  queue_as :default

  def perform user
    SleepManagerClient.workers_services_assign [user.sleep_mngr_guid], user.contest.sleep_services
  end
end
