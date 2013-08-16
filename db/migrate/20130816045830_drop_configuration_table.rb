class DropConfigurationTable < ActiveRecord::Migration
  def up
    remove_column :parameters, :configuration_id
    add_column :parameters, :configuration_file_id, :integer
    add_index :parameters, [:configuration_file_id, :name], unique: true
  end

  def down
  end
end
