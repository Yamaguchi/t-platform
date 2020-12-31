class CreateRoleEntityPrivileges < ActiveRecord::Migration[6.0]
  def change
    create_table :role_entity_privileges do |t|
      t.belongs_to :role
      t.belongs_to :entity_privilege

      t.timestamps
    end
  end
end
