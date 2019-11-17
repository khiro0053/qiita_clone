Rails.application.routes.draw do
  namespace :api, format: 'json' do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth"
      resources :articles
    end
  end
end
