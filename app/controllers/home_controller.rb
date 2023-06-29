class HomeController < ApplicationController
    skip_before_action :authenticate_user!, :only => [:index]
    def index
      @courses = Course.all.limit(3)
      @latest_courses = Course.all.limit(3).order(created_at: :desc)
      @enrollments = Enrollment.all
    end

    def activity
      @activities = PublicActivity::Activity.all
    end
  end