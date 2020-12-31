module TokensHelper
  def token_type_label(token_type)
    case token_type
    when Tapyrus::Color::TokenTypes::REISSUABLE
      "Reissuable"
    when Tapyrus::Color::TokenTypes::NON_REISSUABLE
      "Non Reissuable"
    when Tapyrus::Color::TokenTypes::NFT
      "NFT"
    end
  end

  def transaction_token_sender(transaction)
    transaction.sender&.user&.name || transaction.sender&.user&.email || ((transaction.operation == "issue" || transaction.operation == "reissue") ? "-" : "(Unknown)")
  end

  def transaction_operation_type_label(transaction)
    transaction.operation
  end

  def transaction_token_amount(transaction)
    transaction.amount
  end

  def transaction_token_receiver(transaction)
    transaction.receiver&.user&.name || transaction.receiver&.user&.email || "(Unknown)"
  end

end
