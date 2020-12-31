class CreateUserRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :user_roles do |t|
      t.belongs_to :role
      t.belongs_to :user
      t.boolean :primary, null: false, default: false
      t.timestamps
    end
  end
end
