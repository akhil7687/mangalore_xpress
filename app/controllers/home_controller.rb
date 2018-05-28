class HomeController < ApplicationController

  def index
    @enable_banner = true
    respond_to do |format|
      format.html
    end
  end

  def real_estate

    respond_to do |format|
      format.html
    end
  end

  def download_market_price



    respond_to do |format|
      format.html
    end
  end

  def reports
    respond_to do |format|
      format.html
    end
  end


  def cards
    respond_to do |format|
      format.html {render :layout => 'cards'}
    end
  end

  def feeds
    @feeds = Feed.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def services
    @services = ServiceCategory.enabled_services()
    respond_to do |format|
      format.html
    end
  end

  def contact_us
    respond_to do |format|
      format.html
    end
  end

  def about_us
    respond_to do |format|
      format.html
    end
  end
end
