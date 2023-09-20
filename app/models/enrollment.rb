class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  # Course.find_each { |course| Course.reset_counters(course.id, :enrollments) } to reset cache_counter
  belongs_to :user

  validates :user, :course, presence: true

  validates_presence_of :rating, if: :review?
  validates_presence_of :review, if: :rating?

  validates_uniqueness_of :user_id, scope: :course_id # user can enroll only once
  validates_uniqueness_of :course_id, scope: :user_id 

  scope :pending_review, -> {where(rating: [0, nil, ""], review: [0, nil, ""])}

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  def to_s
    user.to_s + " " + course.to_s
  end  

  after_save do
    unless rating.nil? || rating.zero?
      course.update_rating
    end
  end

  after_destroy do
    course.update_rating
  end



  protected
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
