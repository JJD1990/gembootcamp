class LessonPolicy < ApplicationPolicy
    class Scope < Scope
      # NOTE: Be explicit about which records you allow access to!
      def resolve
        scope.all
      end
    end

    def show?
      @user.has_role?(:admin) || @record.course.user.id == user.id || @record.course.bought(@user)
    end    

    def edit?
     @user.present? && @record.course.user.id == @user.id
    end  
  
    def update?
      @record.course.user.id == @user.id
    end  
  
    def new?
      @user.has_role?(:Teacher)
    end  
  
    def create?
      @record.course.user.id == @user.id
    end  
  
    def destroy?
      @record.course.user.id == @user.id
    end
  end
  