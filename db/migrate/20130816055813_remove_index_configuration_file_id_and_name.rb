class RemoveIndexConfigurationFileIdAndName < ActiveRecord::Migration
  def up
    remove_index :parameters, column: [:configuration_file_id, :name]
  end

  def down
    
  end
end
