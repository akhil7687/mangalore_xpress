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


  def update_token

    ut = UserToken.where("app_id=?",params[:app_token]).take

    if ut.blank?
      ut = UserToken.new
      ut.app_id = params[:app_token]
      ut.save
    end

    respond_to do |format|
      format.json{render :json=>{:update_status=>"success",:status=>200}}
    end
  end

  def download_market_price
    require 'net/http'
    require 'json'

    url = 'https://www.kdkgowdas.com/market_reports.json'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    data.each do |dat|
      m = MarketPrice.where("item_id=?",dat['item_id']).take
      if m.blank?
        m = MarketPrice.new
      end
      m.item_id = dat['item_id']
      m.name = dat['name']
      m.item_group = dat['item_group']
      m.save
    end

    redirect_to root_path
    return

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
