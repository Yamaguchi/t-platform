class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.integer :amount
      t.string :operation
      t.belongs_to :sender
      t.belongs_to :receiver
      t.belongs_to :token
      t.belongs_to :owner
      t.timestamps
    end
  end
end
