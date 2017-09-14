module I18nAdmin
  class ApplicationController < I18nAdmin.root_controller_parent.constantize
    include FontAwesome::Rails::IconHelper

    helper_method :current_locale

    if (authentication_method = I18nAdmin.authentication_method)
      before_action authentication_method
    end

    def current_user
      if (current_user_method = I18nAdmin.current_user_method)
        send(current_user_method)
      end
    end

    def current_locale
      @current_locale ||= (params[:locale] || I18n.locale).to_sym
    end
  end
end
