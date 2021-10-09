class User < ApplicationRecord
  validates :name, :email, :city, :school, :institution, :contest_site, :grade, presence: true
  validates :name, uniqueness: { scope: :contest }
  belongs_to :contest, inverse_of: :users
  has_many :solutions, inverse_of: :user
  has_many :results, inverse_of: :user
end
