module RailsAdmin
  module Config
    module Actions
      class IpsMismatch < Base
        register_instance_option(:member) { true }

        register_instance_option(:only) { Contest }

        register_instance_option(:link_icon) { 'fa fa-balance-scale' }

        register_instance_option(:http_methods) { [:get] }

        register_instance_option :controller do
          proc do
            @collection = @object.solutions
              .where('solutions.ips != users.registration_ips')
              .group('users.id')
              .pluck('users.registration_ips', 'users.secret', 'array_agg(solutions.id)')
              .map { |ips, secret, solution_ids| [ips, secret, Solution.includes(:task).where(id: solution_ids)] }
          end
        end
      end
    end
  end
end
