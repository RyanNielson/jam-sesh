class PagesController < ApplicationController
  def home

    respond_to do |format|
      format.html { render }
      format.js { }
    end
  
  end

  def listen

  end
end
