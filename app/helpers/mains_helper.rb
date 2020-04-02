module MainsHelper

  def user_name_fetch(finder_id)
    fetched_user = User.find_by(id:finder_id)
    fetched_user.name
  end

end
