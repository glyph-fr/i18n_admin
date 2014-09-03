module I18nAdmin
  class ApplicationController < ::ApplicationController
    if (authentication_method = I18nAdmin.authentication_method)
      before_filter authentication_method
    end

    def current_user
      if (current_user_method = I18nAdmin.current_user_method)
        send(current_user_method)
      end
    end
  end
end
