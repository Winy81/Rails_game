module ApplicationHelper

  def message_manager(key)
    case key
    when "notice"
      "success"
    when "warning"
      "warning"
    when "alert"
      "danger"
    end
  end

end
