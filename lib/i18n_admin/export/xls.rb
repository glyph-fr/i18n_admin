module I18nAdmin
  module Export
    class XLS < Export::Base
      register :xls, self

      PAGE_LENGTH = 32_000.0

      attr_reader :spreadsheet, :sheet
      attr_accessor :export_file

      def perform(locale, client_locale: I18n.locale)
        @locale = locale
        @client_locale = client_locale
        @spreadsheet = Spreadsheet::Workbook.new
        @sheet = spreadsheet.create_worksheet

        add_headers!

        run
        save
      end

      def run
        default_format = Spreadsheet::Format.new(text_wrap: true)

        index = 0

        translations.each do |key, value|
          value = value.to_s
          original_translation = original_translations[key].to_s
          max_length = [value.length, original_translation.length].max
          pages = (max_length / PAGE_LENGTH).ceil

          pages.times do |page|
            index += 1

            translation_key = if pages > 1
              "#{ key } (#{ page + 1 } / #{ pages })"
            else
              key
            end

            start_offset = page * PAGE_LENGTH

            row = sheet.row(index)
            row.default_format = default_format
            row.push(translation_key)
            row.push(original_translation[start_offset, PAGE_LENGTH])
            row.push(value[start_offset, PAGE_LENGTH])
          end
        end
      end

      def save
        spreadsheet.write(file_path)

        source = File.open(file_path, 'rb')
        self.export_file = ExportFile.create!(job_id: job_id, file: source)
      ensure
        if defined?(source) && source
          source.close
          File.unlink(source.path)
        end
      end

      def file_path
        @file_path ||= ['', 'tmp', file_name].join('/')
      end

      def file_name
        @file_name ||= I18n.with_locale(client_locale) do
          I18n.t('i18n_admin.exports.file.name', {
            time: Time.now.strftime('%Y_%m_%d-%H_%M'),
            lang: locale,
            ext: 'xls'
          })
        end
      end

      def monitoring_data(_, state)
        { url: export_file.file.url } if state == 'complete'
      end

      def export_file
        @export_file ||= ExportFile.find_by_job_id(job_id)
      end

      private

      def add_headers!
        sheet.row(0).replace(
          [
            I18n.t('i18n_admin.exports.file.columns.key'),
            I18n.t('i18n_admin.exports.file.columns.original', lang: I18n.default_locale),
            I18n.t('i18n_admin.exports.file.columns.translated', lang: locale)
          ]
        )

        format = Spreadsheet::Format.new weight: :bold

        sheet.row(0).default_format = format

        sheet.column(0).width = 30
        sheet.column(1).width = 100
        sheet.column(2).width = 100
      end

      def job_id
        @job_id ||= jid || randomize_job_id
      end

      def randomize_job_id
        ['sync', (Time.now.to_f * 1000).round, rand(1000)]
      end
    end
  end
end
