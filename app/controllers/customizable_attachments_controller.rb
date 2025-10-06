class CustomizableAttachmentsController < ApplicationController
  before_action { head :forbidden unless current_user }

  def show
    secret = current_user.metadata_secret
    file = customizable_attachment.file
    service = service_klass.new file, customizable_attachment.options, secret
    send_data service.data, filename: file.filename.to_s, type: file.content_type
  end

  private

  def customizable_attachment
    @customizable_attachment ||= CustomizableAttachment.find params[:id]
  end

  def current_user
    return @current_user if instance_variable_defined? :@current_user
    return @current_user = nil if params[:user_secret].blank?

    @current_user = customizable_attachment.contest.users.find_by secret: params[:user_secret]
  end

  def service_klass
    case customizable_attachment.action
    when 'default'
      CustomizableAttachmentService::Base
    when 'open_xml'
      CustomizableAttachmentService::OpenXml
    when 'access'
      CustomizableAttachmentService::Access
    end
  end
end
