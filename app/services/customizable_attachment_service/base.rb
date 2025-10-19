module CustomizableAttachmentService
  class Base
    def initialize file, options, secret
      @file = file
      @options = options
      @secret = secret
    end

    def validation_status all_secrets
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
  end
end
