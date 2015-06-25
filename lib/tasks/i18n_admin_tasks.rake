# desc "Explaining what the task does"
# task :i18n_admin do
#   # Task goes here
# end

namespace :i18n do
  namespace :translations do
    task export: :environment do
      format = (ENV['format'] || 'xls').to_sym
      locale = (ENV['locale'] || I18n.default_locale).to_sym

      data = I18nAdmin::Export.for(format).export(locale)

      file_name = ['translations', locale, format].join('.')
      file_path = Rails.root.join('tmp', file_name)

      File.open(file_path, 'wb') do |file|
        file.write(data)
      end

      puts "Exported translations to : #{ file_path }"
    end

    task import: :environment do
      format = (ENV['format'] || 'xls').to_sym
      locale = (ENV['locale'] || I18n.default_locale).to_sym
      file_path = ENV['file']
      file = File.open(file_path, 'rb')

      data = I18nAdmin::Import.for(format).import(locale, file)

      puts "Imported translations from : #{ file_path }"
    end
  end
end
