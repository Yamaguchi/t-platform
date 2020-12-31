class Users::RolesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_role, only: [:destroy]

  def new
    @roles = Role.accessible(current_user).all - @user.roles
    @role_user = RoleUser.new(create_params)
  end

  def create
    @role = Role.accessible(current_user).find(create_params[:role])
    @role_user = RoleUser.new(role: @role, user: @user)
    if @role_user.save!
      redirect_to edit_user_path(@user), notice: 'The Role has been added successfully.'
    else
      render action: :new
    end
  end

  def destroy
    @user.roles.destroy(@role)
    redirect_to edit_user_path(@user), notice: 'The Role has been removed successfully.'
  rescue ActiveRecord::RecordInvalid => e
  end

  private

  def set_user
    @user = User.accessible(current_user).find(params[:user_id])
  end

  def set_role
    @role = Role.accessible(current_user).find(params[:id])
  end

  def create_params
    params.fetch(:role_user, {}).permit(:role)
  end
end

