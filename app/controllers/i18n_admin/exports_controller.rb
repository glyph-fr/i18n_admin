module I18nAdmin
  class ExportsController < I18nAdmin::ApplicationController
    def show
      respond_to do |format|
        format.html do
          @job_id = Export::XLS.perform_async(current_locale.to_s)
          render 'queued', layout: false
        end

        format.xls do
          job = Export::XLS.new
          job.perform(current_locale.to_s)

          redirect_to job.export_file.file.url
        end
      end
    end
  end
end
