class Roles::EntityPrivilegesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_role
  before_action :set_entity_privilege, only: [:edit, :update, :destroy]

  def new
    @entity_privilege = EntityPrivilege.new(create_params)
  end

  def create
    @entity_privilege = EntityPrivilege.new(create_params)
    @entity_privilege.save_by!(current_user)
    redirect_to edit_role_path(@role), notice: 'The Privilege has been created successfully.'
  rescue ActiveRecord::RecordInvalid => e
    render action: :new
  end

  def edit
    
  end

  def update
    @entity_privilege.update_by!(current_user, update_params)
    redirect_to edit_role_path(@entity_privilege.role), notice: 'The Privilege has been updated successfully.'
  rescue ActiveRecord::RecordInvalid => e
    render action: :edit
  end

  def destroy
    @entity_privilege.destroy_by!(current_user)
    redirect_to edit_role_path(@entity_privilege.role), notice: 'The Privilege has been deleted successfully.'
  rescue ActiveRecord::RecordInvalid => e
  end

  private

  def set_role
    @role = Role.accessible(current_user).find(params[:role_id])
  end

  def set_entity_privilege
    @entity_privilege = EntityPrivilege.accessible(current_user).find(params[:id])
  end

  def create_params
    params.fetch(:entity_privilege, {}).permit(:entity_name, :read_access, :create_access, :update_access, :delete_access).merge(owner: current_user, role: @role)
  end

  def update_params
    params.fetch(:entity_privilege, {}).permit(:read_access, :create_access, :update_access, :delete_access).merge(role: @role)
  end
end

