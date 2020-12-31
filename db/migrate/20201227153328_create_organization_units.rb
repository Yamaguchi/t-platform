class CreateOrganizationUnits < ActiveRecord::Migration[6.0]
  def change
    create_table :organization_units do |t|
      t.string :name
      t.string :ancestry, index: true

      t.belongs_to :owner
      t.timestamps
    end
  end
end
