# I18nAdmin

Admin panel to translate Rails apps with `I18n::Backend::KeyValue` stores.

**Warning : Only PostgreSQL is supported due to HSTORE field type usage to store translations**

It works by creating a I18n backend chain and plugging a custom backend before
the original YAML backend.

When you translate a key, it is stored in a `HSTORE` field, with one database
row per locale. This allows for fast translations fetching on request start.

The translations are then merged with the ones existing in the YAML, and cached
for the request duration using the
[RequestStore](https://github.com/steveklabnik/request_store) gem.

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

I18nAdmin gives you an admin panel to translate your static contents.
It's accessible at the Engine mount point that you choosed when running
the install generator.

The default URL is `/i18n-admin`

### Authentication

To plug the engine with your authentication system, you can pass a method
name to execute in a `before_action` filter in the I18nAdmin controllers.

This can be done in the initializer file generated at
`config/initializers/i18n_admin.rb` :

```ruby
I18nAdmin.config do |config|
  config.authentication_method = :authenticate_user!
end
```

### Excluding keys from the admin

To avoid some keys to be displayed in the translation admin, you can use a
Regex in the initializer file. The regex is matched against the whole key path
(e.g. "time.formats.short")

```ruby
I18nAdmin.config do |config|
  # Exclude all date and time formats from translations
  config.excluded_keys_pattern = /^(date|time)/
end
```

## UI locale

The locale is defined from the rails' `I18n.locale`, which is automatically
added in the `<html>` tag `lang` attribute.

The JS app then taps into this locale to set its default locale and allow
displaying side-by-side the content with the default locale and the current
locale's translation for the key

## Licence

This project rocks and uses MIT-LICENSE.
