class ConfigurationFilesController < ApplicationController
  require 'net/http'

  def delete_files
    ConfigurationFile.delete_files
    respond_to do |format|
      format.html {
        redirect_to root_path
      }
      format.js {
        render nothing: true
      }
    end
  end

  def download
    config_file = ConfigurationFile.find_by_name!(params[:id])
    url         = URI.parse(config_file.amazon_aws_url)
    result      = Net::HTTP.get(url)
    if !result[/<Code>AccessDenied<\/Code>/]
      path = config_file.absolute_file_path
      File.open(path, 'wb') do |f|
        f.write(result)
      end
      send_file path, type: 'application/text', filename: config_file.name
    else
      flash[:error] = 'Configuration file does not exist on server'
      redirect_to config_file
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Configuration file does not exist'
    redirect_to config_file
  end

  def search
    # Search page for parameters
    @parameters = Parameter.all
    @title      = 'Search'
  end

  def show
    # Show all parameters for a single configuration file
    @config_file = ConfigurationFile.find_by_slug!(params[:id])
    @parameters  = @config_file.parameters
    @title       = @config_file.name
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Configuration file does not exist'
    redirect_to root_path
  end

  def upload
    # Upload a configuration file and save its parameters
    file = params[:upload]
    if file
      name = file.original_filename.downcase
      path = File.join('public/files', name)
      # Save file and write to it from uploaded file
      config_file      = ConfigurationFile.find_by_name(name)
      config_file      = ConfigurationFile.new if !config_file
      config_file.name = name
      config_file.save
      # Save parameters from uploaded file
      config_file.save_parameters_from_file(file)
      flash[:success] = 'Configuration file uploaded, parameters saved'
    else
      flash[:notice] = 'You did not upload any file'
    end
    redirect_to :search_path
  end
end
