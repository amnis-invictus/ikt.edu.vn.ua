class Result < ApplicationRecord
  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  belongs_to :user, inverse_of: :results
  belongs_to :task, inverse_of: :results
end
