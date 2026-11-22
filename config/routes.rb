Rails.application.routes.draw do
  root "products#index"

  # Каталог
  resources :products, only: [:index, :show] do
    resources :reviews, only: [:create, :destroy]
  end
  get "catalog/:category", to: "products#index", as: :category

  # Реєстрація та автентифікація
  get    "signup",  to: "users#new"
  post   "signup",  to: "users#create"
  get    "login",   to: "sessions#new"
  post   "login",   to: "sessions#create"
  delete "logout",  to: "sessions#destroy"
  resource :profile, only: [:show, :edit, :update], controller: "users"

  # Кошик
  resource :cart, only: [:show, :destroy]
  resources :cart_items, only: [:create, :update, :destroy]

  # Оформлення замовлення, доставка та оплата
  resources :orders, only: [:index, :new, :create, :show] do
    resource :payment, only: [:new, :create]
  end

  # Зворотний зв'язок
  get  "contacts", to: "feedback_messages#new"
  post "contacts", to: "feedback_messages#create"

  # Адміністративна панель
  namespace :admin do
    root "dashboard#index"
    resources :products, except: [:show]
    resources :orders, only: [:index, :show, :update]
    resources :feedback_messages, only: [:index, :update]
  end
end
