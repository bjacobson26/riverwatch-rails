Rails.application.routes.draw do
  get 'pages/index'
  get 'lagoon', to: 'pages#lagoon', as: 'lagoon'
  get 'highway', to: 'pages#highway', as: 'highway'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#index"
end
