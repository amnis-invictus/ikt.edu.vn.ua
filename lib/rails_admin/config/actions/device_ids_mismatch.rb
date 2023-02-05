module RailsAdmin
  module Config
    module Actions
      class DeviceIdsMismatch < Base
        register_instance_option(:member) { true }

        register_instance_option(:only) { Contest }

        register_instance_option(:link_icon) { 'fa fa-balance-scale' }

        register_instance_option(:http_methods) { [:get] }

        register_instance_option :controller do
          proc do
            @collection = @object.solutions
              .where('solutions.device_id != users.device_id')
              .group('users.id')
              .pluck('users.device_id', 'users.judge_secret', 'array_agg(solutions.id)')
              .map do |did, judge_secret, solution_ids|
              [did, judge_secret,
                Solution.includes(:task).where(id: solution_ids)]
            end
          end
        end
      end
    end
  end
end
