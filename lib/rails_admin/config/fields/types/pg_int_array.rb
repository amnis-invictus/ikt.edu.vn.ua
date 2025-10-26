module RailsAdmin
  module Config
    module Fields
      module Types
        class PgIntArray < PgArray
          def parse_input params
            params[name] = params[name].split(',').filter_map { _1.strip.to_i } if params[name].is_a? ::String
          end
        end
      end
    end
  end
end
