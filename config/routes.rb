Rails.application.routes.draw do
  devise_for :groupements
  devise_for :members
  get 'home/index'

  root to: 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
