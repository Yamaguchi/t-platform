class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.belongs_to :organization_unit

      t.belongs_to :owner
      t.timestamps
    end
  end
end
