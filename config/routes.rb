Rails.application.routes.draw do
  resources :enrollments
  devise_for :users
  resources :courses do
    resources :lessons
  end  
  resources :users, only: [:index, :edit, :show, :update]
  root 'home#index'
  get 'home/activity'
  # get 'static_pages/privacy_policy'
  get 'privacy_policy', to: 'home#privacy_policy'
end
