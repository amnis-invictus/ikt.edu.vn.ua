module HTTPClient
  METHOD_TO_HTTP_CLASS = {
    get: Net::HTTP::Get,
    post: Net::HTTP::Post,
    put: Net::HTTP::Put,
    delete: Net::HTTP::Delete,
  }.freeze

  class << self
    def make_request method, uri, body: nil, headers: {}, timeout: nil
      request = METHOD_TO_HTTP_CLASS[method].new uri, headers
      request.body = body unless body.nil?
      request_options = { use_ssl: uri.scheme == 'https' }
      if timeout
        request_options[:open_timeout] = timeout
        request_options[:read_timeout] = timeout
      end
      Net::HTTP.start(uri.hostname, uri.port, request_options) { _1.request request }
    end
  end
end
