class Criterion < ApplicationRecord
  validates :name, :position, :limit, exclusion: { in: [nil], message: 'cannot be null' }
  belongs_to :task, inverse_of: :criterions, counter_cache: true
end
