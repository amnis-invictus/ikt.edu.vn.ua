class CustomizableAttachmentsController < ApplicationController
  before_action { head :forbidden unless current_user }

  def show
    secret = current_user.metadata_secret
    file = customizable_attachment.file
    service = customizable_attachment.service_klass.new file, customizable_attachment.options, secret
    send_data service.data, filename: file.filename.to_s, type: file.content_type
  end

  private

  def customizable_attachment
    @customizable_attachment ||= contest.customizable_attachments.find params[:id]
  end
end
