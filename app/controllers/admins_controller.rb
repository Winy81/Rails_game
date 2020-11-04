class AdminsController < ApplicationController

  before_action :is_user_admin?

  UPDATE_USER_ATTRS = [:name, :email, :role]
  UPDATE_BUDGET_ATTR = [:amount]

  def index

  end

  def edit_user
    @user = User.find_by(id:params[:id])
  end

  def edit_character
    @character = Character.find_by(id:params[:id])
  end

  def user_update_by_admin
    @user = User.find_by(id:params[:id])
    if @user.update_attributes(update_user_params) && @user.wallet.update_attributes(update_wallet_params)
      redirection_to_admin_index_path('notice', 'User details has updated.')
    else
      redirection_to_admin_index_path('alert','User details has NOT been updated.')
    end
  end

  def character_update_by_admin
    @character = Character.find_by(id:params[:id])
    redirect_to admins_path
  end

  def account_management
    @users = User.all.user_in_asc_id_order
  end

  def character_management
    @characters = Character.all.character_in_asc_id_order
  end

  def search
    @results = Services::SearchEngine::Search.new(params[:search_params], params[:commit]).response
  end

  private

  def is_user_admin?
    current_user.role == 'admin' ? true : redirection_to_characters_path('alert', 'You have no admin privileges')
  end

  def update_user_params
    params.require(:user).permit(UPDATE_USER_ATTRS)
  end

  def update_wallet_params
    params.require(:user).permit(UPDATE_BUDGET_ATTR)
  end
end
