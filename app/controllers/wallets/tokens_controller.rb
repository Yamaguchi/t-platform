class Wallets::TokensController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wallet, only: [:new, :create, :edit, :update, :reissue, :reissue!, :transfer, :transfer!]
  before_action :set_token, only: [:edit, :update, :reissue, :reissue!, :transfer, :transfer!]

  def new
    @token = TokenIssueForm.new(token_create_params)
  end

  def create
    @token = TokenIssueForm.new(token_create_params)
    @token.create_by!(current_user)
    redirect_to root_path, notice: 'The token has been issued successfully.'
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error(e)
    render action: :new
  end

  def edit
    @token_form = TokenIssueForm.from_token(@token)
  end

  def update
    @token_form = TokenIssueForm.from_token(@token)
    @token_form.update_by!(current_user, token_update_params)
    redirect_to root_path, notice: 'The token has been updated successfully.'
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error(e)
    render action: :edit
  rescue StandardError => e
    Rails.logger.error(e)
    flash.now[:alert] = 'Updating the token has failed.'
    render action: :edit
  end

  def reissue
    @token_form = TokenReissueForm.new(token_reissue_params)
  end

  def reissue!
    @token_form = TokenReissueForm.new(token_reissue_params)
    @token_form.reissue_by!(current_user)
    redirect_to root_path, notice: 'The token has been reissued successfully.'
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error(e)
    render action: :reissue
  rescue StandardError => e
    Rails.logger.error(e)
    flash.now[:alert] = 'Reissuing the token has failed.'
    render action: :reissue
  end

  def transfer
    @receivers = User.accessible(current_user) - [ current_user ]
    @token_transfer_form = TokenTransferForm.new(token_transfer_params)
  end

  def transfer!
    @receivers = User.accessible(current_user) - [ current_user ]
    @token_transfer_form = TokenTransferForm.new(token_transfer_params)
    @token_transfer_form.transfer_by!(current_user)
    redirect_to root_path, notice: 'The token has been transferred successfully.'
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error(e)
    Rails.logger.error(e.backtrace)
    Rails.logger.error(@token_transfer_form.errors.full_messages)
    render action: :transfer
  rescue StandardError => e
    Rails.logger.error(e)
    Rails.logger.error(e.backtrace)
    flash.now[:alert] = 'Transfering the token has failed.'
    render action: :transfer
  end

  private

  def set_wallet
    @wallet = Wallet.accessible(current_user).find(params[:wallet_id])
  end

  def set_token
    @token = Token.accessible(current_user).find(params[:id])
  end

  def token_create_params
    params.fetch(:token_issue_form, {}).permit(:name, :amount, :token_type).merge(issuer: @wallet)
  end

  def token_update_params
    params.fetch(:token_issue_form, {}).permit(:name).merge(issuer: @wallet)
  end

  def token_reissue_params
    params.fetch(:token_reissue_form, {}).permit(:amount).merge(issuer: @wallet, token: @token)
  end

  def token_transfer_params
    params.fetch(:token_transfer_form, {}).permit(:receiver, :amount).merge(sender: @wallet, token: @token)
  end
end

