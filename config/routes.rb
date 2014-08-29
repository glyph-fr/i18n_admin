I18nAdmin::Engine.routes.draw do
  resources :translations, only: [:index] do
    collection do
      patch '/', action: 'update', as: 'update'
    end
  end
end
