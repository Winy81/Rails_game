class AdminsController < ApplicationController

  before_action :is_user_admin?

  def index

  end

  def account_management

  end

  def character_management

  end

  private

  def is_user_admin?
    current_user.role == "admin" ? true : redirection_to_characters_path('alert', 'you have no admin privileges')
  end

end
