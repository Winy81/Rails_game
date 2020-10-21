module AdminsHelper

  include Services::DateTransformer

  def is_the_user_admin?(user)
    user.role == 'admin' ? true : false
  end
end
