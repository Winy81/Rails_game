class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  add_flash_types :success, :warning, :danger

  def request_path_recognise_helper(params)
    if params == 'from_feeding'
      "feeding"
    elsif params == 'from_activity'
      "activity"
    end
  end

end
