class Contest < ApplicationRecord
  validates :display_name, presence: true
  validates :cities, presence: true
  has_many_attached :files
  has_many :tasks, inverse_of: :contest
  has_many :users, inverse_of: :contest
end
