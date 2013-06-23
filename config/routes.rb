Resume::Application.routes.draw do
  resources :users do
    resources :projects
    resources :infos
    put 'update_by_github', :on => :member
  end

  devise_for :users, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" }

  authenticated :user do
    root :to => 'users#index'
  end

  as :user do
    root to: "devise/sessions#new"
  end
end
