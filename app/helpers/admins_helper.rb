module AdminsHelper

  include Services::DateTransformer

  def is_the_user_admin?(user)
    user.role == 'admin' ? true : false
  end

  def active_character(character)
    character.hibernated || character.manualy_hibernated == true ? 'no' : 'yes'
  end

end
