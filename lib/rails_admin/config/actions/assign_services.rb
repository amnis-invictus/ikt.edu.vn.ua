module RailsAdmin
  module Config
    module Actions
      class AssignServices < Base
        register_instance_option(:member) { true }

        register_instance_option(:only) { [Contest, User] }

        register_instance_option(:link_icon) { 'fa fa-bell' }

        register_instance_option(:http_methods) { [:get] }

        register_instance_option :controller do
          proc do
            case @object
            when Contest
              worker_ids = @object.users.where.not(sleep_mngr_guid: nil).pluck(:sleep_mngr_guid)
              @result = SleepManagerClient.workers_services_assign worker_ids, @object.sleep_services
            when User
              @result = SleepManagerClient.workers_services_assign [@object.sleep_mngr_guid], @object.contest.sleep_services
            end
          end
        end
      end
    end
  end
end
