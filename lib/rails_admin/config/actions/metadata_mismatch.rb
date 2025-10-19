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
            @collection = @object.solutions.includes(:user, file_attachment: :blob).find_each.map do |solution|
              user = solution.user
              file = solution.file

              customizable_attachment = @object.customizable_attachments.find do |ca|
                ca.file.filename == file.filename
              end

              if customizable_attachment.nil?
                status = :ignored
              else
                service = customizable_attachment.service_klass.new \
                  file, customizable_attachment.options, user.metadata_secret

                status = service.validation_status all_secrets
              end

              [user.judge_secret, solution.task.display_name, status]
            end
          end
        end
      end
    end
  end
end
