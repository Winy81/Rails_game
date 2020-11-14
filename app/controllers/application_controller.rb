class ApplicationController < ActionController::Base

  before_action :wallet_view

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

  def redirection_to_characters_path(type, message, extra='')
    output_type = type.to_sym
    redirect_to characters_path, {output_type => "#{message} #{extra}"}
  end

  def redirection_to_character_path(current_character,type, message, extra='')
    output_type = type.to_sym
    redirect_to character_path(current_character), {output_type => "#{message} #{extra}"}
  end

  def redirection_to_admin_index_path(type, message)
    output_type = type.to_sym
    redirect_to admins_path, {output_type => "#{message}"}
  end

end
