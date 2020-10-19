class AdminsController < ApplicationController

  before_action :is_user_admin?

  def index

  end

  def account_management
    @users = User.all.user_in_asc_id_order
  end

  def character_management
    @characters = Character.all
  end

  def search
    binding.pry
    @results = params[:search_params]
  end

  private

  def is_user_admin?
    current_user.role == "admin" ? true : redirection_to_characters_path('alert', 'you have no admin privileges')
  end

end
