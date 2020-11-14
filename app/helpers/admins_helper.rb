module AdminsHelper

  include Services::DateTransformer

  def is_the_user_admin_api?(user)
    user['role'] == 'admin' ? true : false
  end

  def is_the_user_admin?(user)
    user.role == 'admin' ? true : false
  end

  def active_character(character)
    character['hibernated'] || character['manualy_hibernated'] == true ? 'no' : 'yes'
  end

  def alive_check(character)
    character.status == 'alive' ? true : false
  end

end
