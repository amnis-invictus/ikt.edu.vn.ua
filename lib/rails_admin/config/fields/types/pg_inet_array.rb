module RailsAdmin
  module Config
    module Fields
      module Types
        class PgInetArray < PgArray
          def parse_input params
            params[name] = params[name].split(',').filter_map { cast_value _1 } if params[name].is_a? ::String
          end

          private

          def cast_value value
            IPAddr.new value.strip
          rescue ArgumentError
            nil
          end
        end
      end
    end
  end
end
