I18nAdmin.config do |config|
  # User authentication method for the admin panel
  #
  # config.authentication_method = :authenticate_user!

  # Method to retrieve the current user
  #
  # config.current_user_method = :current_user

  # Define a pattern that will exclude keys from the shown administrable
  # translations
  #
  # For example, to exclude all activerecord translations :
  #   config.excluded_keys_pattern = /^activerecord\./
  #
  # config.excluded_keys_pattern = nil

  # When exporting translations, all translated models are exported.
  # If you want to be able to whitelist exportable models, set the
  # following option to true
  #
  # config.whitelist_models = false

  # If you want imports and exports to be processed asynchronously through
  # `ActiveJob`, set the following to true.
  #
  # config.async_io = false
end
