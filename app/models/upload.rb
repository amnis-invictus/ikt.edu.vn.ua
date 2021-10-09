class Upload
  include ActiveModel::Model

  attr_accessor :secret, :solutions

  validates :user, presence: true

  def user
    @user ||= User.find_by secret: secret
  end

  def solutions_attributes= attributes
    attributes = attributes.values if attributes.is_a? Hash
    @solutions = attributes.filter_map { user.solutions.build _1 if _1.key? :file }
  end

  def save
    solutions.each &:save if valid?
  end
end
