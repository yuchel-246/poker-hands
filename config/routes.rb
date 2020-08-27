# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get root to: 'cards#top'
  post '/judgment'  => 'cards#judgment'
  patch '/judgment' => 'cards#judgment'
  get '/result' => 'cards#result'
  mount Base::API => '/'
end
