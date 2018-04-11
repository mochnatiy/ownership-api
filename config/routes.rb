Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1 do
      scope '/' do
        match 'authenticate' => 'user_sessions#create', via: :post
        match 'register' => 'users#create', via: :post

        namespace(:ownership_transfers) do
          post :request_operation
          post :complete_operation
        end

        resources :properties, only: [:index, :create]
      end
    end
  end
end
