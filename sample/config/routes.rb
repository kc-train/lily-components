Rails.application.routes.draw do
  root 'home#index'

  get 'demo/switch', to: 'demo#switch'
end