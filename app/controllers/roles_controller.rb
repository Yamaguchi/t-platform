class RolesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  def index
    @roles = Role.accessible(current_user)
  end

  def show
    
  end

  def new
    @role = Role.new(create_params)
  end

  def create
    @role = Role.new(create_params)
    @role.save_by!(current_user)
    redirect_to action: :index
  rescue ActiveRecord::RecordInvalid => e
    render action: :new
  end

  def edit

  end

  def update
    @role.update_by!(current_user, update_params)
    redirect_to roles_path, notice: 'The role has been updated successfully.'
  rescue ActiveRecord::RecordInvalid => e
    render action: :edit
  end

  def destroy
    @role.destroy_by!(current_user)
    redirect_to roles_path, notice: 'The role has been deleted successfully.'
  rescue ActiveRecord::RecordInvalid => e
    
  end

  private

  def set_role
    @role = Role.accessible(current_user).find(params[:id])
  end

  def create_params
    params.fetch(:role, {}).permit(:name, :description).merge(owner: current_user)
  end

  def update_params
    params.fetch(:role, {}).permit(:name, :description)
  end
end

