module RailsAdmin
  module Config
    module Fields
      module Types
        class PgArray < Base
          register_instance_option(:formatted_value) { value.join ', ' if value.present? }
        end
      end
    end
  end
end
