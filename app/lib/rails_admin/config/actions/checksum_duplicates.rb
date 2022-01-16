module RailsAdmin
  module Config
    module Actions
      class ChecksumDuplicates < Base
        register_instance_option(:member) { true }

        register_instance_option(:only) { Contest }

        register_instance_option(:link_icon) { 'fa fa-balance-scale' }

        register_instance_option(:http_methods) { [:get] }

        register_instance_option :controller do
          proc do
            @collection = @object.solutions.joins(file_attachment: :blob)
              .group('active_storage_blobs.checksum')
              .having('count(distinct solutions.user_id) > 1')
              .pluck('active_storage_blobs.checksum', 'array_agg(solutions.id)')
              .to_h
              .transform_values { Solution.includes(:user, :task).with_attached_file.where(id: _1) }
          end
        end
      end
    end
  end
end
