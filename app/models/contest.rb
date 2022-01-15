class Contest < ApplicationRecord
  validates :display_name, presence: true
  validates :cities, presence: true
  validates :contest_sites, presence: true
  has_one_attached :all_archive
  has_one_attached :last_archive
  has_one_attached :author_solution
  has_one_attached :judge_solution
  has_one_attached :criterias
  has_one_attached :preliminary_results
  has_one_attached :final_results
  has_many :tasks, inverse_of: :contest
  has_many :users, inverse_of: :contest
end
