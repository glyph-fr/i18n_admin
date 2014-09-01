module I18nAdmin
  class TranslationsController < I18nAdmin::ApplicationController
    def index
      respond_to do |format|
        format.html
        format.json do
          fetch_translations

          if params[:q]
            @translations = I18nAdmin::Translations.search(params[:q], @translations)
          end

          @translations = Kaminari.paginate_array(@translations)
          @translations = @translations.page(params[:page]).per(60)

          render json: {
            translations: @translations,
            meta: {
              count: @translations.total_count,
              per: 60
            }
          }
        end
      end
    end

    def update
      if I18nAdmin::Translations.update(locale, translation_params)
        render json: { translation: translation_params }, status: 201
      else
        render json: { translation: translation_params }, status: 422
      end
    end

    private

    def translation_params
      params.require(:translation).permit(:key, :value)
    end

    def fetch_translations
      @translations ||= I18nAdmin::Translations.as_json_for_locale(locale)
    end

    def locale
      @locale ||= params[:locale] || I18n.locale
    end
  end
end
