I18nAdmin.config do |config|
  # User authentication method for the admin panel
  #
  # config.authentication_method = :authenticate_user!

  # Method to retrieve the current user
  #
  # config.current_user_method = :current_user

  # Define the Key Value store that will be used by the engine to store your
  # translations
  #
  # For example, to use Redis :
  #  config.key_value_store = Redis.new
  #
  # config.key_value_store = {}

  # Define a pattern that will exclude keys from the shown administrable
  # translations
  #
  # For example, to exclude all activerecord translations :
  #   config.excluded_keys_pattern = /^activerecord\./
  #
  # config.excluded_keys_pattern = nil
end