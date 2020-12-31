class WalletsController < ApplicationController
  before_action :authenticate_user!
  def create
    current_user.create_wallet(current_user)
    redirect_to :root
  end
end

