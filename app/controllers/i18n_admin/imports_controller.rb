module I18nAdmin
  class ImportsController < I18nAdmin::ApplicationController
    def show
      respond_to do |format|
        format.json do
          job = ImportJob.find(params[:id])
          render json: job.as_json(only: [:id, :filename, :state])
        end
      end
    end

    def new
    end

    def create
      unless params[:file].present?
        flash[:error] = t('i18n_admin.imports.please_choose_file')
        render 'new'
        return
      end

      @job = ImportJob.create!(locale: current_locale, filename: params[:file].original_filename)
      Import::Job.perform_async(current_locale, params[:file], @job.id)

      render 'processing'
    end
  end
end
