$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "i18n_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "i18n_admin"
  s.version     = I18nAdmin::VERSION
  s.authors     = ['Valentin Ballestrino']
  s.email       = ['vala@glyph.fr']
  s.homepage    = 'http://www.glyph.fr'
  s.summary     = "Small admin panel to translate your Rails app"
  s.description = "Small admin panel to translate your Rails app"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'ember-rails'
  s.add_dependency 'kaminari'

  s.add_development_dependency "sqlite3"
end
