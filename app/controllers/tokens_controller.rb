class TokensController < ApplicationController
  before_action :authenticate_user!
  before_action :set_token, only: [:show]

  def index
    @tokens = Token.accessible(current_user)
  end

  def show
  end

  private

  def set_token
    @token = Token.accessible(current_user).find(params[:id])
  end
end
