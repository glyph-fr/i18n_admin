I18nAdmin::Engine.routes.draw do
  resources :translations, only: [:index, :update]

  resource :export, only: [:show]
  resource :import, only: [:show, :new, :create]
end
