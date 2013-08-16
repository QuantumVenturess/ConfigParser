Configparser::Application.routes.draw do
  get "parameters/list"

  resources :configuration_files do
    member do
      get :download
    end
  end

  root to: 'configuration_files#search'

  # Configurations
  match 'delete-files', to: 'configuration_files#delete_files', 
    as: :delete_files
  match 'search',   to: 'configuration_files#search', as: :search_path
  match 'upload',   to: 'configuration_files#upload', as: :upload_path

  # Parameters
  match 'parameter-list', to: 'parameters#parameter_list', 
    as: :parameter_list_path

end
