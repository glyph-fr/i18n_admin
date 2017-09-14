module I18nAdmin
  class TranslationsController < I18nAdmin::ApplicationController
    before_action :fetch_translations

    def index
      @translations = @translations.search(params[:q]) if params[:q]
      @translations = @translations.page(params[:page]).per(60)

      @locales = I18n.available_locales
    end

    def update
      translation = @translations.find(params[:id])
      translation.value = translation_params[:value]

      I18nAdmin::Translations.update(translation)
      render partial: 'translation', locals: { translation: translation }
    end

    private

    def translation_params
      params.require(:translation).permit(:value)
    end

    def fetch_translations
      @translations = I18nAdmin::Translations.translations_for(current_locale)
    end
  end
end
