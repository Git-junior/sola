Rails.application.routes.draw do
  devise_for :users
  get 'photos/index'
  root to: "photos#index"
end
