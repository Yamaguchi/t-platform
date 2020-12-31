# frozen_string_literal: true

class Wallet < Entity
  belongs_to :user
  has_many :tokens, foreign_key: :issuer_id

  before_create :create_internal_wallet

  def create_internal_wallet
    @wallet = Glueby::Wallet.create
    self.wallet_id = @wallet.id
    self.receive_address = @wallet.internal_wallet.receive_address
  end

  def get_balance
    @wallet ||= Glueby::Wallet.load(wallet_id)
    @wallet.balances
  end

  def add_address(address)
    unless self.receive_address
      self.receive_address = address 
      save!
    end
  end
end
