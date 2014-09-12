# I18nAdmin

Admin panel to translate Rails apps with `I18n::Backend::KeyValue` stores.

## Install

Add to your Gemfile and bundle :

```ruby
gem 'i18n_admin', github: 'glyph-fr/i18n_admin'
```

Run the install generator which will mount the engine and create an initializer
template to configure the gem, and create necessary migration :

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

## Interface locale

The locale is defined from the rails' `I18n.locale`, which is automatically
added in the `<html>` tag `lang` attribute.

## Licence

This project rocks and uses MIT-LICENSE.