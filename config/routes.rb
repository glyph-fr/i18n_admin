I18nAdmin::Engine.routes.draw do
  resources :translations, only: [:index, :update]

  resource :export, only: [:show]
  resource :import, only: [:new, :create]
end
