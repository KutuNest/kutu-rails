Rails.application.routes.draw do


  devise_for :members, path: '', path_names: {sign_in: '/login', sign_out: '/logout', sign_up: '/signup'}

  get "uploads/:id/:basename.:extension" => 'transaction#receipt', :as => :receipt
  get 'transactions' => 'transaction#list', :as => :transactions
  get 'transaction/:id' => 'transaction#show', :as => :transaction

  get 'transaction/:id/send-money' => 'transaction#send_money', :as => :send_money
  get 'transaction/:id/reject' => 'transaction#reject', :as => :reject
  get 'transaction/:id/confirm' => 'transaction#confirm', :as => :confirm

  post 'upload-receipt/:id' => 'transaction#upload_receipt', :as => :upload_receipt
  get 'dashboard' => 'dashboard#index', :as => :dashboard

  get 'support' => 'home#support', :as => :support
  post 'setting' => 'home#setting', :as => :setting

  get 'members' => 'dashboard#members', :as => :members
  get 'groups' => 'dashboard#groups', :as => :groups


  root to: 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
