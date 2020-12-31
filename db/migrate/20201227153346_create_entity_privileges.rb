class CreateEntityPrivileges < ActiveRecord::Migration[6.0]
  def change
    create_table :entity_privileges do |t|
      t.belongs_to :role
      t.string :entity_name
      t.integer :read_access
      t.integer :create_access
      t.integer :update_access
      t.integer :delete_access

      t.belongs_to :owner
      t.timestamps
    end
  end
end
