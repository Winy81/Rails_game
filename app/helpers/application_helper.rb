module ApplicationHelper

  def message_manager(key)
    case key
    when "notice"
      "secondary border-success border-top-0 border-bottom-0 border-3"
    when "warning"
      "secondary border-warning border-top-0 border-bottom-0 border-3"
    when "alert"
      "secondary border-danger border-top-0 border-bottom-0 border-3"
    end
  end

  def wallet_view
    if current_user && has_user_created_character != 0
      current_users_wallet = Wallet.find_by(user_id:current_user.id)
      output = "Wallet:  #{current_users_wallet.amount} Gold"
      output
    end
  end

  private

  def has_user_created_character
    Character.where(user_id:current_user.id).count
  end

end
