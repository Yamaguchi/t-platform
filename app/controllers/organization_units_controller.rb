class OrganizationUnitsController < ApplicationController
  before_action :authenticate_user!
  def show
    @organization_unit = OrganizationUnit.accessible(current_user).find(params[:id])
  end
end

