Myapp::Application.routes.draw do
  scope "(:locale)", :locale => /en|ar/ do
    devise_scope :user do
      root :to => 'devise/sessions#new'
      delete "sign out" => "devise/session#destroy"
    end
    devise_for :users, path: "auth", path_names: { sign_in: 'login', sign_out: '', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }
    
    get 'home/index' => 'home#index'    
    get 'factory/new' => 'factory#new'
    get 'addnew' => 'home#addnew'
    post 'addnew' => 'home#addnew'
    get 'destroy' => 'home#destroy'
    get 'etsr' => 'home#etsr'
    get 'loadexisting' => 'home#loadexisting'
    post "modalclass" => 'home#modalclass'
    get "modalclass"  => 'home#modalclass'
    post "modalprop" => 'home#modalprop'
    get "modalprop"  => 'home#modalprop'
    get 'settings' => 'setting#index'
    post 'settings' => 'setting#index'
    get 'view' => 'home#view'
    post 'view' => 'home#view'
    post 'update' => 'home#update'
    get 'update' => 'home#update'
    get 'dictionary_detail' => 'home#dictionary_detail'  
    get 'ajax_property' => 'home#ajax_property'  
    get 'template_search' => 'home#template_search'
  end 
end
