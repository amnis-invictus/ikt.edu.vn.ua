module SleepManagerClient
  module_function

  def otp_valid? guid, otp
    return false unless guid.is_a?(String) && guid.present? && otp.is_a?(String) && otp.present?

    make_request(:post, "/workers/#{guid}/verify_otp", { otp: }).code == 200
  rescue StandardError => e
    Rails.logger.error "SleepManagerClient#otp_valid? #{e.class} #{e.message}"
    false
  end

  def workers_services_assign worker_ids, service_ids
    make_request(:put, '/workers_services', { worker_ids:, service_ids: })
  rescue StandardError => e
    Rails.logger.error "SleepManagerClient#workers_services_assign #{e.class} #{e.message}"
    nil
  end

  def workers_services_remove worker_ids, service_ids
    make_request(:delete, '/workers_services', { worker_ids:, service_ids: })
  rescue StandardError => e
    Rails.logger.error "SleepManagerClient#workers_services_remove #{e.class} #{e.message}"
    nil
  end

  private

  def make_request method, path, body
    credentials = Rails.application.credentials.integration.sleep_manager
    uri = URI.parse credentials.uri + path
    headers = { 'Content-Type' => 'application/json', 'Authorization' => "Token token=#{credentials.token}" }
    HTTPClient.make_request method, uri, body: body.to_json, headers:
  end
end
