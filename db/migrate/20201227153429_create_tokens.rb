class CreateTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :tokens do |t|
      t.string :name
      t.string :color_id
      t.string :payload
      t.belongs_to :issuer

      t.belongs_to :owner
      t.timestamps
    end
  end
end
