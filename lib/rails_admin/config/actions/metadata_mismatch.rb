module RailsAdmin
  module Config
    module Actions
      class MetadataMismatch < Base
        register_instance_option(:member) { true }

        register_instance_option(:only) { Contest }

        register_instance_option(:link_icon) { 'fa fa-balance-scale' }

        register_instance_option(:http_methods) { [:get] }

        register_instance_option :controller do
          proc do
            all_secrets = @object.users.pluck :metadata_secret
            @collection = []
            @object.solutions.each do |solution|
              user = solution.user
              file = solution.file

              customizable_attachments = @object.customizable_attachments.find do |a|
                a.file.filename == file.filename
              end
              if customizable_attachments.nil?
                @collection << [user.judge_secret, solution.task.display_name, :ignored]
                next
              end

              service_klass = case customizable_attachments.action
                              when 'default'
                                CustomizableAttachmentService::Base
                              when 'open_xml'
                                CustomizableAttachmentService::OpenXml
                              when 'access'
                                CustomizableAttachmentService::Access
                              end

              service = service_klass.new \
                file, customizable_attachments.options, user.metadata_secret

              status = service.valid? all_secrets

              @collection << [user.judge_secret, solution.task.display_name, status]
            end
          end
        end
      end
    end
  end
end
