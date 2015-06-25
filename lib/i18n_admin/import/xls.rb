module I18nAdmin
  module Import
    class XLS < Import::Base
      register :xls, self

      attr_reader :file, :spreadsheet, :sheet

      def self.import(locale, file)
        import = new(locale, file)
        import.run
      ensure
        file.close
      end

      def initialize(locale, file)
        @locale = locale
        @spreadsheet = Spreadsheet.open(file.path)
        @sheet = spreadsheet.worksheet(0)
      end

      def run
        I18n.with_locale(locale) do
          (1..(sheet.row_count - 1)).each do |index|
            key, _, value = sheet.row(index)
            update_translation(key, value)
          end

          save_updated_models
        end

        errors.empty?
      end
    end
  end
end
