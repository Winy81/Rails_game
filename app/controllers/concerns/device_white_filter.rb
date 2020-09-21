module DeviceWhiteFilter

  extend ActiveSupport::Concern

  included do
    before_action :set_devise_extra_attribute, if: :devise_controller?
  end

  def set_devise_extra_attribute
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end

end