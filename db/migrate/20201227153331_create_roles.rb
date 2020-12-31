class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.string :description

      t.belongs_to :owner
      t.timestamps
    end
  end
end
