Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'signup' => 'accounts#signup'
  get 'login' => 'accounts#login'
  post 'create_account' => 'accounts#create_account'
  post 'create_login' => 'accounts#create_login'
  delete 'logout' => "accounts#logout"
  get 'account_active' => 'accounts#account_active'
  get 'update_active/:account_id' => 'accounts#update_active'


  # resources :posts
  get 'posts/new'
  post 'posts/create'
  get 'posts/create_thumb/:post_id/:is_thumb' => 'posts#create_thumb'
  get 'posts/show_posts/:post_id' => "posts#show_posts"
  get 'posts/show_replys/:comment_id/:point' => 'posts#show_replys'
  post 'posts/create_comment' => 'posts#create_comment'
  get 'posts/delete_comment/:comment_id' => 'posts#delete_comment'

end