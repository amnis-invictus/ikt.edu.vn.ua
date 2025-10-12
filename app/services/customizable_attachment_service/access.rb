module CustomizableAttachmentService
  class Access < Base
    # Access encodes metadata in the form of UTF-16LE strings
    ENCODING = 'UTF-16LE'.freeze
    # Access encodes metadata in the form of UTF-16LE
    # '#$AANNNNAAAANNNN' format in UTF-16LE encoding
    BINARY_METADATA_REGEXP =
      /#\0\$\0[A-Z]\0[A-Z]\0[0-9]\0[0-9]\0[0-9]\0[0-9]\0[A-Z]\0[A-Z]\0[A-Z]\0[A-Z]\0[0-9]\0[0-9]\0[0-9]\0[0-9]\0/
    private_constant :ENCODING, :BINARY_METADATA_REGEXP

    def data
      replace_str = @options.fetch 'replace_str', '#$AA0000AAAA0000'

      raise ArgumentError, 'Secret len must be equal to replace_str len' if @secret.length != replace_str.length

      content = @file.download.force_encoding 'BINARY'
      content.gsub! replace_str.encode(ENCODING).force_encoding('BINARY'), @secret.encode(ENCODING).force_encoding('BINARY')
      content
    end

    private

    def load_secrets_from_file
      content = @file.download.force_encoding 'BINARY'
      secrets = Set.new
      content.scan(BINARY_METADATA_REGEXP).each do |match|
        secrets << match.force_encoding(ENCODING).encode('UTF-8')
      end

      secrets
    end
  end
end
