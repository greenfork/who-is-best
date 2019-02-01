Rails.application.routes.draw do
  root 'web#index'
  get 'web/show'
end
