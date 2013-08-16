class CreateConfigurationFiles < ActiveRecord::Migration
  def change
    create_table :configuration_files do |t|
      t.string :name

      t.timestamps
    end
    add_index :configuration_files, :name, unique: true
  end
end
