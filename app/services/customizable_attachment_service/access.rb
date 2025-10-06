module CustomizableAttachmentService
  class Access < Base
    # Access encodes metadata in the form of UTF-16LE null-terminated strings
    ENCODING = 'UTF-16LE'.freeze
    private_constant :ENCODING

    def data
      replace_str = @options.fetch 'replace_str', '#$AA0000AAAA0000'

      raise ArgumentError, 'Secret len must be equal to replace_str len' if @secret.length != replace_str.length

      content = @file.download.force_encoding 'BINARY'
      content.gsub! replace_str.encode(ENCODING).force_encoding('BINARY'), @secret.encode(ENCODING).force_encoding('BINARY')
      content.force_encoding 'BINARY'
    end

    def valid? all_secrets
      secrets_in_file = load_secrets_from_file
      all_secrets_except_current_user = Set.new all_secrets
      all_secrets_except_current_user.delete @secret

      # Condition order is important!
      # We need to check that secrets_in_file does not include secrets of other users
      # before checking if it includes the current user's secret
      # to make sure that file is not shared with other users.
      if secrets_in_file.intersect? all_secrets_except_current_user
        :other_user
      elsif secrets_in_file.include? @secret
        :current_user
      else
        # Includes if secrets_in_file.empty? variant
        :unknown
      end
    end

    private

    def load_secrets_from_file
      # Access encodes metadata in the form of UTF-16LE
      # '#$AANNNNAAAANNNN' format in UTF-16LE encoding
      binary_metadata_regexp =
        /#\0\$\0[A-Z]\0[A-Z]\0[0-9]\0[0-9]\0[0-9]\0[0-9]\0[A-Z]\0[A-Z]\0[A-Z]\0[A-Z]\0[0-9]\0[0-9]\0[0-9]\0[0-9]\0/

      content = @file.download.force_encoding 'BINARY'
      secrets = Set.new
      content.scan(binary_metadata_regexp).each do |match|
        secrets << match.force_encoding(ENCODING).encode('UTF-8')
      end

      secrets
    end
  end
end
