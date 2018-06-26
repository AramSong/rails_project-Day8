Rails.application.routes.draw do
 
  post 'posts/:id/comments/create' => 'comments#create'
  delete 'comments/:id' => 'comments#destroy'
  
  get 'comments/destroy'

  resources :posts
  root 'post#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
