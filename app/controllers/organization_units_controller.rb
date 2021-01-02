class OrganizationUnitsController < ApplicationController
  before_action :authenticate_user!

  def index
    @organization_units = OrganizationUnit.accessible(current_user)
  end

  def show
    @organization_unit = OrganizationUnit.accessible(current_user).find(params[:id])
  end
end

