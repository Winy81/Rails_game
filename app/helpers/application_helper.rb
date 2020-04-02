module ApplicationHelper

  def message_manager(key)
    case key
    when "notice"
      "secondary"
    when "warning"
      "secondary text-warning"
    when "alert"
      "secondary text-danger"
    end
  end

end
