Rails.application.routes.draw do
  root 'web#index'
  get 'web/show'
  get '/download/:name', to: 'web#download', as: :download
end
