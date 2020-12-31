# frozen_string_literal: true

class TokenReissueForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :amount, :integer, default: 1
  attribute :issuer
  attribute :token

  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :issuer, presence: true
  validates :token, presence: true

  def reissue_by!(current_user)
    raise ActiveRecord::RecordInvalid if invalid?
    raise PermissionDenied.new() unless token.can_update?(current_user)
    glueby_wallet = Glueby::Wallet.load(issuer.wallet_id)
    glueby_token = Glueby::Contract::Token.parse_from_payload(token.payload.htb)
    glueby_token.reissue!(issuer: glueby_wallet, amount: amount)
    transaction = Transaction.new(receiver: issuer, operation: :reissue, amount: amount, token: token, owner: token.owner)
    transaction.save_by!(current_user)
  end
end
