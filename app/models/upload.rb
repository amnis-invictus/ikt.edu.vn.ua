class Upload
  include ActiveModel::Model

  attr_accessor :secret, :solutions

  validates :user, presence: true

  def user
    @user ||= User.find_by secret: secret if secret.present?
  end

  def solutions_attributes= attributes
    attributes = attributes.values if attributes.is_a? Hash
    @solutions = attributes.filter_map { Solution.new user: user, **_1 }
  end

  def save
    @solutions = solutions.filter { _1.file.present? }
    solutions.each &:save if valid?
  end
end
