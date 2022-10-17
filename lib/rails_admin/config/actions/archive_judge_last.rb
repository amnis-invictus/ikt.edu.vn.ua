module RailsAdmin
  module Config
    module Actions
      class ArchiveJudgeLast < Base
        register_instance_option(:member) { true }

        register_instance_option(:only) { Contest }

        register_instance_option(:link_icon) { 'icon-download' }

        register_instance_option(:http_methods) { [:get] }

        register_instance_option(:pjax?) { false }

        register_instance_option(:controller) { -> (_) { send_file Archive.new(@object, false, true).build } }
      end
    end
  end
end