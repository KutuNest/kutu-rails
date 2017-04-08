Rails.application.routes.draw do

  get 'member/edit'

  devise_for :members, path: '', path_names: {sign_in: '/login', sign_out: '/logout', sign_up: '/signup'}

  
  get 'transactions' => 'transaction#list', :as => :transactions
  get 'disputes' => 'transaction#disputes', :as => :disputes

  get "transaction-receipt/:id/:basename.:extension" => 'transaction#receipt', :as => :receipt
  get 'dispute/:id' => 'transaction#dispute', :as => :dispute
  get 'transaction/:id' => 'transaction#show', :as => :transaction
  get 'transaction/:id/send-money' => 'transaction#send_money', :as => :send_money
  get 'transaction/:id/reject' => 'transaction#reject', :as => :reject
  get 'transaction/:id/confirm' => 'transaction#confirm', :as => :confirm
  get 'transaction/:id/settle' => 'transaction#settle', :as => :settle

  post 'upload-receipt/:id' => 'transaction#upload_receipt', :as => :upload_receipt

  get 'dashboard' => 'dashboard#index', :as => :dashboard

  get 'support' => 'home#support', :as => :support
  post 'setting' => 'home#setting', :as => :setting

  get 'members' => 'dashboard#members', :as => :members
  get 'groups' => 'dashboard#groups', :as => :groups

  get 'account/add' => 'account#add', :as => :add_account
  post 'account/change-pool-order/:id' => 'account#change_pool_order', :as => :change_pool_order

  post 'member/increase-accounts-limit/:id' => 'member#increase_accounts_limit', :as => :increase_accounts_limit

  get 'member/:id/edit' => 'member#edit', :as => :edit_member
  post 'member/:id' => 'member#update', :as => :update_member
  get 'member/:id' => 'member#show', :as => :member
  get 'member/:id/lock' => 'member#lock', :as => :lock_member
  get 'member/complete' => 'member#complete', :as => :complete_member

  get 'add-pool' => 'dashboard#add_pool', :as => :add_pool
  get 'add-super-user' => 'dashboard#add_super_user', :as => :add_super_user
  get 'add-group' => 'dashboard#add_group', :as => :add_group

  get 'save-group' => 'dashboard#save_group', :as => :save_group
  get 'save-pool' => 'dashboard#save_pool', :as => :save_pool
  get 'save-super-user' => 'dashboard#save_super_user', :as => :save_super_user

  root to: 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
