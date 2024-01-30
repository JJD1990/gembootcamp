Rails.application.routes.draw do
  resources :enrollments do
    get :my_students, on: :collection
  end

  devise_for :users, :controllers => { registrations: 'users/registrations'}
  resources :courses do
    get :purchased, :pending_review, :unapproved, :created, on: :collection
    member do
      get :analytics
      patch :approve
      patch :unapprove
    end
    resources :lessons do
      resources :comments, except: [:index]
      put :sort
      member do
        delete :delete_video
      end
    end
    resources :enrollments, only: [:new, :create]
  end  

  resources :users, only: [:index, :edit, :show, :update]
  root 'home#index'
    get 'activity', to: 'home#activity'
    get 'analytics', to: 'home#analytics'
    namespace :charts do
      get 'users_per_day'
      get 'enrollments_per_day'
      get 'course_popularity'
      get 'money_makers'
    end

    resources :youtube, only: :show

  # get 'static_pages/privacy_policy'
  get 'privacy_policy', to: 'home#privacy_policy'
end
