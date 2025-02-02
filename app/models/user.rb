class User < ApplicationRecord
  attr_accessor :registration_secret, :registration_secret_required

  validates :name, :city, :institution, :grade, presence: true
  validates :name, :secret, :judge_secret, uniqueness: { scope: :contest }
  validates :email, :contest_site, presence: true, unless: :absent?

  with_options if: :registration_secret_required, on: :create do
    validates :registration_secret, presence: true
    validate :registration_secret_must_be_valid
  end

  belongs_to :contest, inverse_of: :users
  has_many :solutions, inverse_of: :user, dependent: :destroy
  has_many :results, inverse_of: :user, dependent: :destroy
  has_many :comments, inverse_of: :user, dependent: :destroy
  has_many :criterion_user_results, inverse_of: :user, dependent: :destroy

  before_validation :assign_secrets, on: :create
  after_commit :send_email, on: :create, if: :email?

  scope :attending, -> { where absent: false }

  private

  def send_email
    UserMailer.email(self).deliver_later
  end

  def registration_secret_must_be_valid
    return unless contest && registration_secret.present?

    provided = registration_secret.downcase
    expected = contest.registration_secret.downcase
    errors.add :registration_secret, :invalid unless ActiveSupport::SecurityUtils.secure_compare provided, expected
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
