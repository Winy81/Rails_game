class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  include DeviceWhiteFilter

  add_flash_types :success, :warning, :danger

  #for device log_in redirect
  def after_sign_in_path_for(current_user)
    characters_path
  end

end
