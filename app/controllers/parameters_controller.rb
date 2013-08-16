class ParametersController < ApplicationController

  def parameter_list
    # Return list of parameters with matching query
    q = params[:q]
    parameters = Parameter.where('name ILIKE ?', "%#{q}%")
    respond_to do |format|
      format.html {
        redirect_to :search_path
      }
      format.js {
        @parameters = parameters
      }
    end
  end

end
