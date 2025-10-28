module SleepManagerClient
  class << self
    def otp_valid? guid, otp
      return false unless guid.is_a?(String) && guid.present? && otp.is_a?(String) && otp.present?

      Rails.logger.debug { "SleepManagerClient verifying OTP for worker #{guid}" }
      response = make_request(:post, "/workers/#{guid}/verify_otp", { otp: })
      return true if response.is_a? Net::HTTPOK

      Rails.logger.error "SleepManagerClient unexpected response #{response.inspect}"
      false
    rescue StandardError => e
      Rails.logger.error "SleepManagerClient #{e.class} #{e.message}"
      false
    end

    def workers_services_assign worker_ids, service_ids
      Rails.logger.debug { "SleepManagerClient assign services #{service_ids.inspect} to workers #{worker_ids.inspect}" }

      response = make_request(:put, '/workers_services', { worker_ids:, service_ids: })
      return true if response.is_a? Net::HTTPNoContent

      Rails.logger.error "SleepManagerClient unexpected response #{response.inspect}"
      false
    rescue StandardError => e
      Rails.logger.error "SleepManagerClient #{e.class} #{e.message}"
      false
    end

    def workers_services_remove worker_ids, service_ids
      Rails.logger.debug { "SleepManagerClient remove services #{service_ids.inspect} from workers #{worker_ids.inspect}" }

      response = make_request(:delete, '/workers_services', { worker_ids:, service_ids: })
      return true if response.is_a? Net::HTTPNoContent

      Rails.logger.error "SleepManagerClient unexpected response #{response.inspect}"
      false
    rescue StandardError => e
      Rails.logger.error "SleepManagerClient #{e.class} #{e.message}"
      false
    end

    private

    def make_request method, path, body
      credentials = Rails.application.credentials.integration.sleep_manager
      uri = URI.parse credentials.uri + path
      headers = { 'Content-Type' => 'application/json', 'Authorization' => "Token token=#{credentials.api_key}" }
      HTTPClient.make_request method, uri, body: body.to_json, headers:, timeout: 15
    end
  end
end
