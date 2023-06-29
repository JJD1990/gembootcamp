class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable
  has_many :courses
  has_many :enrollments

  extend FriendlyId
  friendly_id :email, use: :slugged
  
  rolify
  def to_s
    email
  end

  def username
    self.email.split(/@/).first
  end

  after_create :assign_default_role

  def assign_default_role
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:teacher)
      self.add_role(:student)
    else
      self.add_role(:student) if self.roles.blank?
      self.add_role(:teacher)
    end  
  end  

  validate :must_have_a_role, on: :update

  def online?
    updated_at > 2.minutes.ago
  end
  
  private

  def must_have_a_role
    unless roles.any?
      errors.add(:roles, "User must have atleast one role")
    end  
  end  
end
