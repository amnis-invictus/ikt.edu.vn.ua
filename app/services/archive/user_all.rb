module Archive
  class UserAll < Archive::Base
    ATTACHMENT_NAME = :all_archive

    FILENAME_SUFFIX = :users

    private

    def fetch_secret(user) = user.secret

    def fetch_solutions(user) = user.solutions
  end
end
