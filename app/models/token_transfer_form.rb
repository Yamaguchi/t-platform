# frozen_string_literal: true

class TokenTransferForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :amount, :integer, default: 1
  attribute :sender
  attribute :receiver, :integer
  attribute :token

  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :sender, presence: true
  validates :receiver, presence: true
  validates :token, presence: true

  def transfer_by!(current_user)
    raise ActiveRecord::RecordInvalid if invalid?
    raise PermissionDenied.new() unless token.can_update?(current_user)
    sender_glueby_wallet = Glueby::Wallet.load(sender.wallet_id)
    receiver_wallet = Wallet.accessible(current_user).find(receiver)
    receiver_glueby_wallet = Glueby::Wallet.load(receiver_wallet.wallet_id)
    glueby_token = Glueby::Contract::Token.parse_from_payload(token.payload&.htb || token.color_id&.htb)
    glueby_token.transfer!(sender: sender_glueby_wallet, receiver: receiver_glueby_wallet, amount: amount)
    transaction = Transaction.new(sender: sender, receiver: receiver_wallet, operation: :transfer, amount: amount, token: token, owner: token.owner)
    transaction.save_by!(current_user)
  end
end
