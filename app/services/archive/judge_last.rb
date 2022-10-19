module Archive
  class JudgeLast < Archive::Base
    ATTACHMENT_NAME = :last_judge_archive

    FILENAME_SUFFIX = :judge_last

    private

    def fetch_secret(user) = user.judge_secret

    def fetch_solutions(user) = @contest.tasks.map { user.solutions.where(task: _1).order(:id).last }
  end
end
