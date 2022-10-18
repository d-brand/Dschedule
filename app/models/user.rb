class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable#:confirmable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable
  
  validates :email, uniqueness: true

  has_one :teamcore, dependent: :destroy
  has_many :schedules, dependent: :destroy

  accepts_nested_attributes_for :teamcore
end
