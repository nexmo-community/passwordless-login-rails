Rails.application.routes.draw do
  
  get 'sessions/new'
  get 'sessions/pin'
  root to: 'welcome#index'

  # AUTH
  get  'login',               to: 'sessions#new',           as: 'login'
  post 'login_do',            to: 'sessions#create',        as: 'login_do'
  match 'logout',              to: 'sessions#destroy', via: [:get, :post],       as: 'logout'
  get  'pin',                 to: 'sessions#pin',           as: 'pin'
  post 'pin_verify',          to: 'sessions#pin_verify',    as: 'pin_verify'

  
end
