class CreateBlockchains < ActiveRecord::Migration[6.0]
  def change
    create_table :blockchains do |t|
      t.string :chain, null: false
      t.string :mode, null: false
      t.integer :blocks, null: false
      t.integer :headers, null: false
      t.string :bestblockhash, null: false
      t.bigint :mediantime, null: false
      t.float :verificationprogress, null: false
      t.boolean :initialblockdownload, null: false
      t.bigint :size_on_disk, null: false
      t.boolean :pruned, null: false
      t.timestamps
    end

    add_index :blockchains, :chain, unique: true
  end
end
