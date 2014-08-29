# I18nAdmin

Admin panel to translate Rails apps with `I18n::Backend::KeyValue` stores.

## Install

Add to your Gemfile and bundle :

```ruby
gem 'i18n_admin', github: 'glyph-fr/i18n_admin'
```

Run the install generator which will mount the engine and create an initializer
template to configure the gem :

```bash
rails generate i18n_admin:install
```

## Usage

In the i18n_admin initializer file at `config/initializers/i18n_admin.rb` :

```ruby
I18nAdmin.config do |config|
  config.key_value_store = Redis.new
end
```

## Licence

This project rocks and uses MIT-LICENSE.