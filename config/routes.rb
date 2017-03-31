Rails.application.routes.draw do


  devise_for :members

  get "uploads/:id/:basename.:extension" => 'transaction#receipt', :as => :receipt
  get 'transactions' => 'transaction#list', :as => :transactions
  get 'transaction/:id' => 'transaction#show', :as => :transaction

  post 'upload-receipt/:id' => 'transaction#upload_receipt', :as => :upload_receipt

  get 'dashboard' => 'dashboard#index', :as => :dashboard

  get 'transaction/confirm'

  root to: 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
