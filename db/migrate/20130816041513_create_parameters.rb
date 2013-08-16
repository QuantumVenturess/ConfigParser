class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.integer :configuration_id
      t.string :name
      t.string :value

      t.timestamps
    end

    add_index :parameters, [:configuration_id, :name], unique: true
    add_index :parameters, :value
  end
end
