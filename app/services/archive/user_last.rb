module Archive
  class UserLast < Archive::Base
    ATTACHMENT_NAME = :last_archive

    FILENAME_SUFFIX = :users_last

    private

    def fetch_secret(user) = user.secret

    def fetch_solutions(user) = user.solutions.group_by(&:task_id).map { |_, solutions| solutions.max_by(&:id) }
  end
end
