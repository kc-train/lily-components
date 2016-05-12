Rails.application.routes.draw do
  root 'home#index'

  get '/info' => 'home#info'
end