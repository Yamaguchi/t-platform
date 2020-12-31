class DashboardsController < ApplicationController
  before_action :authenticate_user!
  def index
    @wallets = current_user.wallets
    @tokens = @wallets.map do |wallet|
      balances = wallet.get_balance
      color_ids = balances.map { |k, v| k }.concat(wallet.tokens.map(&:color_id))
      color_ids.uniq!
      color_ids.sort!
      tokens = color_ids.map do |color_id|
        token = Token.accessible(current_user).find_by(color_id: color_id)
        name = token&.name || "(Unknown)"
        amount = balances[color_id] || 0
        color_id = color_id.empty? ? "(TPC)" : color_id
        {name: name, color_id: color_id, amount: amount, token: token}
      end
      [wallet.id, tokens]
    end.to_h
  end
end

