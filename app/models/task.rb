class Task < ApplicationRecord
  validates :display_name, presence: true
  validates :file_names, presence: true
  validates :upload_limit, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  belongs_to :contest, inverse_of: :tasks
  has_many :solutions, inverse_of: :task, dependent: :destroy
  has_many :results, inverse_of: :task, dependent: :destroy

  def accepted_ext
    file_names.map(&File.method(:extname)).join(',') if file_names.present?
  end
end
