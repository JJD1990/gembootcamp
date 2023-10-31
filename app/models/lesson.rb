class Lesson < ApplicationRecord
  include RankedModel # This is the correct module to include
  ranks :row_order, :with_same => :course_id
  belongs_to :course, counter_cache: true
  has_many :user_lessons, dependent: :destroy
  # Course.find_each { |course| Course.reset_counters(course.id, :lessons) } to reset cache_counter
  validates :title, :content, :course, presence: true
  validates :title, uniqueness: true, length: { :maximum => 50 }


  has_rich_text :content

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  def viewed(user)
    self.user_lessons.where(user: user).present?
  end

  def prev
    course.lessons.where("row_order < ?", row_order).order(:row_order).last
  end

  def next
    course.lessons.where("row_order > ?", row_order).order(:row_order).first
  end

  def to_s
    title
  end  
end
