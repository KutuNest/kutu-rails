Rails.application.routes.draw do

  get 'member/edit'

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

  get 'account/add' => 'account#add', :as => :add_account
  post 'account/change-pool-order/:id' => 'account#change_pool_order', :as => :change_pool_order

  get 'member/:id/edit' => 'member#edit', :as => :edit_member
  post 'member/:id' => 'member#update', :as => :update_member
  get 'member/:id' => 'member#show', :as => :member
  get 'member/:id/lock' => 'member#lock', :as => :lock_member
  get 'member/complete' => 'member#complete', :as => :complete_member

  root to: 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
