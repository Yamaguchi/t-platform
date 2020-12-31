class Roles::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_role
  before_action :set_user, only: [:destroy]

  def new
    @users = User.accessible(current_user).all - @role.users
    @role_user = RoleUser.new(create_params)
  end

  def create
    @user = Role.accessible(current_user).find(create_params[:user])
    @role_user = RoleUser.new(role: @role, user: @user)
    if @role_user.save!
      redirect_to edit_role_path(@role), notice: 'The User has been added successfully.'
    else
      render action: :new
    end
  end

  def destroy
    @role.users.destroy(@user)
    redirect_to edit_role_path(@role), notice: 'The User has been removed successfully.'
  rescue ActiveRecord::RecordInvalid => e
  end

  private

  def set_role
    @role = Role.accessible(current_user).find(params[:role_id])
  end

  def set_user
    @user = User.accessible(current_user).find(params[:id])
  end

  def create_params
    params.fetch(:role_user, {}).permit(:user)
  end
end

