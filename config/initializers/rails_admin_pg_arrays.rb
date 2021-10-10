class RailsAdminPgArray < RailsAdmin::Config::Fields::Base
  register_instance_option :formatted_value do
    value.join ', ' unless value.blank?
  end
end

class RailsAdminPgStringArray < RailsAdminPgArray
  def parse_input params
    params[name] = params[name].split(',').collect(&:strip) if params[name].is_a? ::String
  end
end

class RailsAdminPgInetArray < RailsAdminPgArray
  def parse_input params
    params[name] = params[name].split(',').collect(&:strip) if params[name].is_a? ::String
  end
end

RailsAdmin::Config::Fields::Types.register :pg_string_array, RailsAdminPgStringArray
RailsAdmin::Config::Fields::Types.register :pg_inet_array, RailsAdminPgInetArray
