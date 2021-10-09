Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root controller: :home, action: :show

  resources :contests, only: %i[index show] do
    get :content, on: :member

    resources :users, only: %i[index new create]

    resources :solutions, only: %i[new create]

    resources :stats, :results, only: :index
  end
end
