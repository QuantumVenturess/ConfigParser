class AddColumnSlugToConfigurationFiles < ActiveRecord::Migration
  def change
    add_column :configuration_files, :slug, :string
    add_index :configuration_files, :slug
  end
end
