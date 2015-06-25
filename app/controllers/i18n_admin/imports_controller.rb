module I18nAdmin
  class ImportsController < I18nAdmin::ApplicationController
    def new
    end

    def create
      unless params[:file].present?
        flash[:error] = t('i18n_admin.imports.please_choose_file')
        render 'new'
        return
      end

      @import = Import::XLS.new(current_locale, params[:file])

      if @import.run
        flash[:success] = t('i18n_admin.imports.run.success')
        redirect_to new_import_path
      else
        flash[:error] = t('i18n_admin.imports.run.errors')
        render 'new'
      end
    end
  end
end
