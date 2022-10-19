class User < ApplicationRecord
  attr_accessor :registration_secret

  validates :name, :email, :city, :institution, :contest_site, :grade, presence: true
  validates :name, :secret, :judge_secret, uniqueness: { scope: :contest }
  validates :registration_secret, presence: true, on: :create
  validate :registration_secret_must_be_valid, on: :create

  belongs_to :contest, inverse_of: :users
  has_many :solutions, inverse_of: :user, dependent: :destroy
  has_many :results, inverse_of: :user, dependent: :destroy
  has_many :comments, inverse_of: :user, dependent: :destroy
  has_many :criterion_user_results, inverse_of: :user, dependent: :destroy

  before_validation :assign_secrets, on: :create
  after_commit :send_email, on: :create

  private

  def send_email
    UserMailer.email(self).deliver_later
  end

  def registration_secret_must_be_valid
    return unless contest && registration_secret.present?

    unless ActiveSupport::SecurityUtils.secure_compare registration_secret, contest.registration_secret
      errors.add :registration_secret, :invalid
    end
  end

  def assign_secrets
    self.secret = [
      (SecureRandom.random_number(26) + 'A'.ord).chr,
      (SecureRandom.random_number(26) + 'A'.ord).chr,
      format('%04d', SecureRandom.random_number(10_000)),
    ].join

    self.judge_secret = [
      (SecureRandom.random_number(26) + 'A'.ord).chr,
      (SecureRandom.random_number(26) + 'A'.ord).chr,
      format('%04d', SecureRandom.random_number(10_000)),
    ].join
  end
end
