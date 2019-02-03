Rails.application.routes.draw do
  root 'web#index'
  get 'web/show'
  get '/download/:name', to: 'web#download', as: :download
  get '/download_all', to: 'web#download_all', as: :download_all
end
