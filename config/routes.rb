Resume::Application.routes.draw do
  resources :users do
    resources :projects
    resources :infos
  end

  devise_for :users

  root :to => 'users#index'
end
