class StaticController < ApplicationController
  def show
    if current_user
      redirect_to photos_path
    else
      render :action => :about
    end
  end

  def about
  end
end
