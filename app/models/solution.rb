class Solution < ApplicationRecord
  belongs_to :user, inverse_of: :solutions
  belongs_to :task, inverse_of: :solutions
  has_one_attached :file
end
