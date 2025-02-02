class Contest < ApplicationRecord
  validates :display_name, :judge_password, :orgcom_password, :registration_secret, presence: true

  has_one_attached :all_archive
  has_one_attached :last_archive
  has_one_attached :all_judge_archive
  has_one_attached :last_judge_archive
  has_one_attached :author_solution
  has_one_attached :judge_solution
  has_one_attached :criteria
  has_one_attached :preliminary_results
  has_one_attached :final_results
  has_many_attached :additional_content

  has_many :tasks, inverse_of: :contest, dependent: :destroy
  has_many :users, inverse_of: :contest, dependent: :destroy
  has_many :solutions, through: :users

  scope :available, -> { any_active? ? where(archived: false) : self }

  class << self
    def any_active?
      Contest.where(archived: false).where('upload_open OR registration_open').exists?
    end
  end
end
