class Criterion < ApplicationRecord
  validates :name, :position, :limit, exclusion: { in: [nil], message: :blank }
  belongs_to :task, inverse_of: :criterions, counter_cache: true
  has_many :criterion_user_results, inverse_of: :criterion, dependent: :destroy
end
