class AdminsController < ApplicationController

  before_action :is_user_admin?

  def index
    binding.pry
  end

  private

  def is_user_admin?
    current_user.role == "admin"
  end

end
