class CustomizableAttachment < ApplicationRecord
  belongs_to :contest, inverse_of: :customizable_attachments

  has_one_attached :file

  enum :action, { default: 0, open_xml: 1, access: 2 }

  def service_klass
    case action
    when 'default'
      CustomizableAttachmentService::Default
    when 'open_xml'
      CustomizableAttachmentService::OpenXml
    when 'access'
      CustomizableAttachmentService::Access
    end
  end
end
