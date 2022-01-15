class Contest < ApplicationRecord
  validates :display_name, presence: true
  validates :cities, presence: true
  validates :contest_sites, presence: true
  has_one_attached :all_archive_file
  has_one_attached :last_archive_file
  has_many :tasks, inverse_of: :contest
  has_many :users, inverse_of: :contest
end
