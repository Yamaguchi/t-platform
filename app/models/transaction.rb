# frozen_string_literal: true

class Transaction < Entity
  belongs_to :token
  belongs_to :sender, class_name: 'Wallet', optional: true
  belongs_to :receiver, class_name: 'Wallet'
end
