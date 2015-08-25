module I18nAdmin
  module Import
    class XLS < Import::Base
      PAGINATION_PATTERN = /\(\d+ \/ (\d+)\)$/

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
          index = 0

          while (index += 1) < sheet.row_count
            key, value, index = extract_translation_at(index)
            update_translation(key, value)
          end

          save_updated_models
        end

        errors.empty?
      end

      private

      def extract_translation_at(index)
        key, _, value = sheet.row(index)

        if (pagination = key.match(PAGINATION_PATTERN))
          pages = pagination[1].to_i
          key = key.gsub(PAGINATION_PATTERN, '').strip

          (pages - 1).times do |page|
            index += 1
            value += sheet.row(index).pop.to_s
          end
        end

        [key, value, index]
      end
    end
  end
end
