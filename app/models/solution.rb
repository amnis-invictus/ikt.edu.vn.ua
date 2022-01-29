class Solution < ApplicationRecord
  validate :upload_number_must_be_in_task_limit, :file_must_be_attached, :file_name_must_match_task_file_names
  validates_with SameContestValidator, for: %i[user task], message: 'Не вдалося завантажити файл на сервер!'

  belongs_to :user, inverse_of: :solutions
  belongs_to :task, inverse_of: :solutions
  has_one_attached :file

  before_validation :assign_upload_number, on: :create
  after_commit :send_email, on: :create

  delegate :display_name, :upload_limit, :accepted_ext, :file_names, to: :task, prefix: true, allow_nil: true

  private

  def send_email
    SolutionMailer.email(self).deliver_later
  end

  def assign_upload_number
    return unless user && task

    # TODO: fix possible race condition
    self.upload_number = Solution.where(user:, task:).count + 1
  end

  def upload_number_must_be_in_task_limit
    return unless upload_number && task

    errors.add :base, 'Робота вже прийнята!' if upload_number > task.upload_limit
  end

  def file_must_be_attached
    errors.add :file, :blank unless file.attached?
  end

  def file_name_must_match_task_file_names
    return unless task && file.attached?

    unless task.file_names.any? { file.filename.to_s == _1 }
      accepted = task.file_names.map { "\"#{_1}\"" }.join(', ')
      errors.add :base, "\"#{file.filename}\" - не допустима назва файлу. Очікується #{accepted}."
    end
  end
end
