module Archive
  class UserLast < Archive::Base
    ATTACHMENT_NAME = :last_archive

    FILENAME_SUFFIX = :users_last

    private

    def fetch_secret(user) = user.secret

    def fetch_solutions(user) = @contest.tasks.map { user.solutions.where(task: _1).order(:id).last }
  end
end
