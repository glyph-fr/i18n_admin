module I18nAdmin
  module RequestStore
    def request_store
      ::RequestStore
    end

    def store_key_for(*args)
      [:i18n_admin, *args].join(':')
    end
  end
end
