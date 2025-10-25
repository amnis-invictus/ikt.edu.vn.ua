module COHVerification
  extend ActiveSupport::Concern

  private

  def coh_verify
    return if contest.sleep_mngr_disabled?

    @otp_valid = SleepManagerClient.otp_valid? params[:coh_guid], params[:coh_otp]
    return unless contest.sleep_mngr_forced? && !@otp_valid

    @status = :coh_invalid
    CustomLogger.write **logger_params
    render :coh_invalid
  end
end
