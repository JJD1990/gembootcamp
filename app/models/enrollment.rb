class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :user, :course, presence: true

  validates_uniqueness_of :user_id, scope: :course_id # user can enroll only once
  validates_uniqueness_of :course_id, scope: :user_id 

  #user cannot enroll in own course
  validate :cant_subscribe_to_own_course

  def cant_subscribe_to_own_course
    if self.new_record?
      if self.user_id.present?
        if user_id == course.user_id
          errors.add(:base, "You cannot enroll in your own course")
        end
      end  
    end 
  end     

end