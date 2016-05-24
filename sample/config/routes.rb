Rails.application.routes.draw do
  root 'home#index'

  get '/info' => 'home#info'
  
  get  '/get_sample'  => 'home#get_sample'
  post '/post_sample' => 'home#post_sample'
end