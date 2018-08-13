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

  def new_notification
    if user_signed_in? && current_user.is_admin?
    else
      flash[:error]= "You are not admin"
      redirect_to root_path
      return
    end

    respond_to do |format|
      format.html
    end
  end


  def send_notification
    if user_signed_in? && current_user.is_admin?
    else
      flash[:error]= "You are not admin"
      redirect_to root_path
      return
    end

    if params[:title].blank? || params[:body].blank? || params[:target_url].blank?
      flash[:error]= "Please fill all the field"
      redirect_to :back
      return
    end

    fcm = FCM.new(ENV["MXP_FCM_TOKEN"])
    options = {data: {url: params[:target_url],title: params[:title],body: params[:body],:notification_id=>params[:title][0..20], collapse_key: params[:title][0..20]}}
    response = fcm.send_to_topic("members",options)
    puts response

    flash[:success] = "Notification sent"
    redirect_to :back
    return
    respond_to do |format|
      format.html
    end
  end


  def toggle_subscribe
    ut = UserToken.where("app_id=?",params[:app_token]).take
    if ut.present?
      ut.subscribe = params[:subscribe]
      ut.save
    end
    respond_to do |format|
      format.json{render :json=>{:update_status=>"success",:status=>200}}
    end
  end

  def update_token
    ut = UserToken.where("app_id=?",params[:app_token]).take
    if ut.blank? && params[:app_token].present?
      ut = UserToken.new
      ut.app_id = params[:app_token]
      if params[:is_admin].present?
        ut.is_admin = 1
      end
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
    if request.original_url =~ /\/articles/
      @feeds = Feed.articles.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    else
      if params[:lang] == "Kannada"
        cookies[:lang] = "Kannada"
      elsif params[:lang] == "English"
        cookies[:lang] = "English"
      elsif params[:lang] == "All"
        cookies[:lang] = "All"
      end
      if cookies[:lang].blank?
        cookies[:lang] = "All"
      end
      @feeds = Feed.enabled.with_lang(cookies[:lang]).news.order("published_date desc").paginate(:page => params[:page], :per_page => 10)
    end

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
