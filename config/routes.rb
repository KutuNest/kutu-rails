Rails.application.routes.draw do

  devise_for :members, path: '', path_names: {sign_in: '/login', sign_out: '/logout', sign_up: '/signup'}, controllers: { registrations: 'registrations' }

  
  post 'upload-receipt/:id' => 'transaction#upload_receipt', :as => :upload_receipt

  get 'transactions' => 'transaction#list', :as => :transactions
  get 'disputes' => 'transaction#disputes', :as => :disputes

  get 'transaction-receipt/:id/:basename.:extension' => 'transaction#receipt', :as => :receipt
  get 'dispute/:id' => 'transaction#dispute', :as => :dispute
  get 'transaction/:id' => 'transaction#show', :as => :transaction
  get 'transaction/:id/send-money' => 'transaction#send_money', :as => :send_money
  get 'transaction/:id/reject' => 'transaction#reject', :as => :reject
  get 'transaction/:id/confirm' => 'transaction#confirm', :as => :confirm
  get 'transaction/:id/settle' => 'transaction#settle', :as => :settle

  # Dashboard
  get  'dashboard' => 'dashboard#index', :as => :dashboard
  post 'setting' => 'dashboard#setting', :as => :setting
  get  'members' => 'dashboard#members', :as => :members
  get  'groups' => 'dashboard#groups', :as => :groups

  # Account
  get  'account/add' => 'account#add', :as => :add_account
  post 'account/change-pool-order/:id' => 'account#change_pool_order', :as => :change_pool_order

  # Member
  post 'member/increase-accounts-limit/:id' => 'member#increase_accounts_limit', :as => :increase_accounts_limit
  get  'member/:id/edit' => 'member#edit', :as => :edit_member
  post 'member/:id' => 'member#update', :as => :update_member
  get  'member/:id' => 'member#show', :as => :member
  get  'member/:id/lock' => 'member#lock', :as => :lock_member
  get  'member/:id/complete' => 'member#complete', :as => :complete_member
  get  'add-super-user' => 'member#add_super_user', :as => :add_super_user
  get  'add-group' => 'member#add_group', :as => :add_group
  get  'edit-group/:id' => 'member#edit_group', :as => :edit_group
  post  'save-group' => 'member#save_group', :as => :save_group
  post  'update-group/:id' => 'member#update_group', :as => :update_group
  post  'save-super-user' => 'member#save_super_user', :as => :save_super_user


  # Pool
  get  'add-pool' => 'pool#add', :as => :add_pool
  post 'save-pool' => 'pool#save', :as => :save_pool
  get  'pool/:id/edit' => 'pool#edit', :as => :edit_pool
  post 'pool/:id/update' => 'pool#update', :as => :update_pool





  # Home
  get  'support' => 'home#support', :as => :support
  root to: 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
