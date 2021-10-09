class User < ApplicationRecord
  attr_accessor :registration_secret

  validates :name, :email, :city, :institution, :contest_site, :grade, presence: true
  validates :name, uniqueness: { scope: :contest }
  validate :registration_secret_must_be_valid

  belongs_to :contest, inverse_of: :users
  has_many :solutions, inverse_of: :user
  has_many :results, inverse_of: :user

  private

  def registration_secret_must_be_valid
    unless ActiveSupport::SecurityUtils.secure_compare registration_secret, contest.registration_secret
      errors.add :registration_secret, :invalid
    end
  end
end
