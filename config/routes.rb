Rails.application.routes.draw do


  devise_for :members

  get "/uploads/:id/:basename.:extension" => 'transaction#receipt', :as => :receipt

  get 'dashboard/member'

  get 'dashboard/admin'

  get 'dashboard/group'

  get 'transaction/list'

  get 'transaction/show'

  get 'transaction/confirm'

  root to: 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
