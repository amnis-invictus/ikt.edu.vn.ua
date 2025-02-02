module ContestAuthentication
  ROLES = %i[judge orgcom].freeze

  module Helpers
    extend ActiveSupport::Concern

    included do
      ROLES.each { helper_method :"#{_1}?" }
    end

    ROLES.each do |role|
      define_method(:"#{role}?") { session[role] == contest.id }
    end
  end

  class << self
    def login_procedure contest, role, username, password
      ActiveSupport::SecurityUtils.secure_compare(username.to_s, role.to_s) &
        ActiveSupport::SecurityUtils.secure_compare(password.to_s, contest.read_attribute("#{role}_password").to_s)
    end

    def [](role, **)
      raise ArgumentError, "Unknown role: #{role}" unless ROLES.include? role

      @modules ||= {}
      @modules[role] ||= Module.new do
        extend ActiveSupport::Concern

        included do
          before_action(**) do
            next if session[role] == contest.id

            if authenticate_with_http_basic { |u, p| ContestAuthentication.login_procedure contest, role, u, p }
              session[role] = contest.id
            else
              request_http_basic_authentication
            end
          end
        end

        define_method(:sign_out) { session.delete role }
      end
    end
  end
end
