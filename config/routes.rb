Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root controller: :home, action: :show

  resources :contests, only: %i[index show] do
    get :content, on: :member

    resources :users, only: %i[index new create]

    resource :upload, only: %i[new create edit update]

    resources :statistics, :results, only: :index
  end
end
