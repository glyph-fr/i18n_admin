module I18nAdmin
  module Export
    class XLS < Export::Base
      register :xls, self

      PAGE_LENGTH = 32_000.0

      attr_reader :spreadsheet, :sheet

      def self.export(locale)
        export = new(locale)
        export.run
        export.data
      end

      def initialize(locale)
        @locale = locale
        @spreadsheet = Spreadsheet::Workbook.new
        @sheet = spreadsheet.create_worksheet

        add_headers!
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

      def data
        tmp = Tempfile.new('_translations')
        spreadsheet.write(tmp.path)
        source = File.open(tmp.path, 'rb')

        source.read
      ensure
        source.close if defined?(source) && source
      end

      private

      def add_headers!
        sheet.row(0).replace(['Key', 'Original', 'Translated'])

        format = Spreadsheet::Format.new weight: :bold

        sheet.row(0).default_format = format

        sheet.column(0).width = 30
        sheet.column(1).width = 100
        sheet.column(2).width = 100
      end
    end
  end
end
