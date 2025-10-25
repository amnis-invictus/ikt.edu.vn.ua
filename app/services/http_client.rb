module HTTPClient
  METHOD_TO_HTTP_CLASS = {
    get: Net::HTTP::Get,
    post: Net::HTTP::Post,
    put: Net::HTTP::Put,
    delete: Net::HTTP::Delete,
  }.freeze

  module_function

  def make_request method, uri, body: nil, headers: {}
    request = METHOD_TO_HTTP_CLASS[method].new uri, headers
    request.body = body unless body.nil?
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { _1.request req }
  end
end
