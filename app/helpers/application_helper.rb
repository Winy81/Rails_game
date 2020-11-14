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

  def user_admin?(user)
    if user.role == "admin"
      true
    else
      false
    end
  end

end
