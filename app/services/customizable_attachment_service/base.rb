module CustomizableAttachmentService
  class Base
    def initialize file, options, secret
      @file = file
      @options = options
      @secret = secret
    end

    def data
      @file.download
    end

    def valid? _all_secrets
      :current_user
    end
  end
end
