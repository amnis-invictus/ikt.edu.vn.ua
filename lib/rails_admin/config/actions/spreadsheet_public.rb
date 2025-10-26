module RailsAdmin
  module Config
    module Actions
      class SpreadsheetPublic < Base
        register_instance_option(:member) { true }

        register_instance_option(:only) { Contest }

        register_instance_option(:link_icon) { 'fa fa-download' }

        register_instance_option(:http_methods) { %i[get post] }

        register_instance_option(:pjax?) { false }

        register_instance_option :controller do
          proc do
            config_params = params.fetch(:spreadsheet_config_public, {})
              .permit(*Spreadsheet::ConfigPublic.attribute_names)
            @config = Spreadsheet::ConfigPublic.new config_params
            send_file Spreadsheet::Public.new(@object, @config).build if request.post?
          end
        end
      end
    end
  end
end
