class HomeController < ApplicationController

  def index
    @enable_banner = true
    respond_to do |format|
      format.html
    end
  end
end
