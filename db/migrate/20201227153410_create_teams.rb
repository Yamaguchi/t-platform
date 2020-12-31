class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name

      t.belongs_to :owner
      t.timestamps
    end
  end
end
