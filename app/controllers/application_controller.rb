class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  include DeviceWhiteFilter

  add_flash_types :success, :warning, :danger

  #for device log_in redirect
  def after_sign_in_path_for(current_user)
    characters_path
  end

  def wallet_view
    if current_user && has_user_created_character != 0
      current_users_wallet = Wallet.find_by(user_id:current_user.id)
      @amount = current_users_wallet.amount
    end
  end

  def has_user_created_character
    Character.where(user_id:current_user.id).count
  end

end
