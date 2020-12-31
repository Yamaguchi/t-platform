class CreateWallets < ActiveRecord::Migration[6.0]
  def change
    create_table :wallets do |t|
      t.belongs_to :user
      t.string :wallet_id
      t.string :receive_address

      t.belongs_to :owner
      t.timestamps
    end
  end
end
