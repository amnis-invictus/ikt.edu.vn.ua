module Archive
  class JudgeAll < Archive::Base
    ATTACHMENT_NAME = :all_judge_archive

    FILENAME_SUFFIX = :judge_all

    private

    def fetch_secret(user) = user.judge_secret

    def fetch_solutions(user) = user.solutions
  end
end
