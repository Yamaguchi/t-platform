class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = User.accessible(current_user)
  end

  def show
  end

  def edit
  end

  def update
    @user.update_by!(current_user, update_params)
    redirect_to users_path, notice: 'The user has been updated successfully.'
  rescue ActiveRecord::RecordInvalid => e
    render action: :edit
  end

  private

  def set_user
    @user = User.accessible(current_user).find(params[:id])
  end

  def update_params
    params.fetch(:user, {}).permit(:name)
  end
end

