class Course < ApplicationRecord
  include PublicActivity::Model
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, :short_description, :language, :price, :level,  presence: true
  validates :description, presence: true, length: { :minimum => 5 }
  validates :title, uniqueness: true, length: { :maximum => 50 }
  validates :price, numericality: { greater_than_or_equal_to: 0}
  validates :avatar, presence: true
  validates :avatar, attached: true, content_type: ['image/png', 'image/jpeg', 'image/jpg'], size: {less_than: 500.kilobytes, message: 'Must be less than 500 Kilobytes'}
  belongs_to :user, counter_cache: true
  # User.find_each { |user| User.reset_counters(user.id, :courses) } to reset cache_counter
  has_many :lessons, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error
  has_many :user_lessons, through: :lessons

  has_one_attached :avatar

  scope :latest, -> { limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }


  def to_s
    title
  end
    
  has_rich_text :description
   
  LANGUAGES = [:"English", :"Russian", :"Polish", :"Spanish"]
  
  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end
  
  LEVELS = [:"Beginner", :"Intermediate", :"Advanced"]
  def self.levels
    LEVELS.map { |level| [level, level] }
  end

  tracked owner: Proc.new{ |controller, model| controller.current_user }

  def progress(user)
    unless self.lessons_count.zero?
      user_lessons.where(user: user).count/self.lessons_count.to_f*100
    end
  end

  def bought(user)
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).any?
  end 

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, (enrollments .average(:rating).round(2).to_f)
    else
      update_column :average_rating, (0)
    end
  end
end
