module I18nAdmin
  module Export
    class XLS < Export::Base
      register :xls, self

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

        translations.each_with_index do |(key, value), index|
          row = sheet.row(index + 1)

          row.default_format = default_format
          row.push(key)
          row.push(original_translations[key])
          row.push(value)
        end
      end

      def data
        tmp = Tempfile.new('_translations')
        spreadsheet.write(tmp.path)
        source = File.open(tmp.path, 'rb+')

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
