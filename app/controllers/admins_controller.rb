class AdminsController < ApplicationController

  before_action :is_user_admin?

  UPDATE_ATTRS = [:name, :email, :role]

  def index

  end

  def show_user
    @user = User.find_by(id:params[:id])
  end

  def user_update_by_admin
    binding.pry
    @user = User.find_by(id:params[:id])
    if @user.update_attributes(update_user_params)
        redirect_to admins_path
      else
        render :show_user
      end
    end

  def account_management
    @users = User.all.user_in_asc_id_order
  end

  def character_management
    @characters = Character.all
  end

  def search
    @results = Services::SearchEngine::Search.new(params[:search_params]).data_response
  end

  private

  def is_user_admin?
    current_user.role == "admin" ? true : redirection_to_characters_path('alert', 'You have no admin privileges')
  end

  def update_user_params
    params.require(:user).permit(UPDATE_ATTRS)
  end

end
