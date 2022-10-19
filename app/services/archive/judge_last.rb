module Archive
  class JudgeLast < Archive::Base
    ATTACHMENT_NAME = :last_judge_archive

    FILENAME_SUFFIX = :judge_last

    private

    def fetch_secret(user) = user.judge_secret

    def fetch_solutions(user) = user.solutions.group_by(&:task_id).map { |_, solutions| solutions.max_by(&:id) }
  end
end
