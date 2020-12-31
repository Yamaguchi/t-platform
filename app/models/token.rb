# frozen_string_literal: true

class Token < Entity
  belongs_to :issuer, class_name: 'Wallet'

  has_many :transactions

  validates :name, presence: true
  validates :color_id, presence: true, uniqueness: true

  def token_type
    Tapyrus::Color::ColorIdentifier.parse_from_payload(self.color_id.htb).type
  end

  def reissuable?
    token_type == Tapyrus::Color::TokenTypes::REISSUABLE
  end

  def balance
    self.transactions.where(operation: [:issue, :reissue]).map(&:amount).sum
  end
end
