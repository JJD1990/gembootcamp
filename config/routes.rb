Rails.application.routes.draw do
  resources :enrollments do
    get :my_students, on: :collection
  end
  devise_for :users
  resources :courses do
    get :purchased, :pending_review, :created, on: :collection
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end  
  resources :users, only: [:index, :edit, :show, :update]
  root 'home#index'
    get 'activity', to: 'home#activity'
  # get 'static_pages/privacy_policy'
  get 'privacy_policy', to: 'home#privacy_policy'
end
