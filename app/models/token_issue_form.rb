# frozen_string_literal: true

class TokenIssueForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :token_type, :integer, default: Tapyrus::Color::TokenTypes::NONE
  attribute :amount, :integer, default: 1
  attribute :issuer
  attribute :token

  validates :name, presence: true
  validates :token_type, presence: true, numericality: { only_integer: true }
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :issuer, presence: true

  def self.from_token(token)
    new(name: token.name, token_type: token.token_type, issuer: token.issuer, token: token)
  end

  def create_by!(current_user)
    raise ActiveRecord::RecordInvalid if invalid?
    ActiveRecord::Base.transaction do
      glueby_wallet = Glueby::Wallet.load(issuer.wallet_id)
      glueby_token = Glueby::Contract::Token.issue!(issuer: glueby_wallet, token_type: token_type, amount: amount)
      token = Token.new(
        name: name, 
        issuer: issuer, 
        color_id: glueby_token.color_id.to_hex, 
        payload: glueby_token.to_payload&.bth,
        owner: current_user
      )
      if token.invalid?
        self.errors.merge!(token.errors)
        raise ActiveRecord::RecordInvalid
      end
      token.save_by!(current_user)
      transaction = Transaction.new(receiver: issuer, operation: :issue, amount: amount, token: token, owner: token.owner)
      transaction.save_by!(current_user)
      transaction
    end
  end

  def update_by!(current_user, params)
    raise ActiveRecord::RecordInvalid if invalid?
    ActiveRecord::Base.transaction do
      token.update_by!(current_user, params)
    end
  end
end
