module I18nAdmin
  class ExportsController < I18nAdmin::ApplicationController
    def show
      respond_to do |format|
        format.xls do
          data = Export::XLS.export(current_locale)

          send_data data, filename: export_filename,
                          disposition: :attachment,
                          type: 'application/vnd.ms-excel'
        end
      end
    end

    private

    def export_filename
      [
        'export-traductions',
        Time.now.strftime('%Y%m%d%H%M'),
        current_locale,
        'xls'
      ].join('.')
    end
  end
end
