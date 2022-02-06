class Comment < ApplicationRecord
  validates :value, exclusion: { in: [nil], message: 'cannot be null' }

  belongs_to :task
  belongs_to :user

  def as_json(*) = { user: user.secret, value: }
end
