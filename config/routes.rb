Rails.application.routes.draw do
  root "projects#index"

  resources :projects
  resources :projects, only: :show do
    resources :comments, except: %i[index destroy]
  end

  devise_for :users, path: "", path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }

  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "changes_history/:entity_type/:id",  to: "histories#show", as: :changes_history
end
