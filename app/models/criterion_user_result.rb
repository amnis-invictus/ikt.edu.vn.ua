class CriterionUserResult < ApplicationRecord
  validates :value, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: -> (r) { r.criterion.limit } }

  belongs_to :criterion
  belongs_to :user

  def as_json(*) = { user: user.secret, criterion: criterion_id, value: }
end
