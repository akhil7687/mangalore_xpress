class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  # GET /feeds
  # GET /feeds.json
  def index
    if params[:type].blank?
      @feeds = Feed.where("is_article is null or is_article=0").where("category is null").order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    else
      @feeds = Feed.where("is_article=1").order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    end
    respond_to do |format|
      format.html
      format.json{
        render :json => @feeds.as_json
      }
    end
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
  end

  # GET /feeds/new
  def new
    @feed = Feed.new
  end

  # GET /feeds/1/edit
  def edit
  end


  def news_cats
    @cats = Feed.where("category is not null").pluck(:category).uniq
    respond_to do |format|
      format.json{render :json=>{:categories=>@cats}}
    end
  end

  def load_feed

    NewsScrapeWorker.perform_at(Time.now)

    Feed.load_news
    
    Feed.load_from_daiji

    respond_to do |format|
      format.json{render :json=>{:update_status=>"success",:status=>200}}
    end
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(feed_params)

    respond_to do |format|
      if @feed.save
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        format.json { render :show, status: :created, location: @feed }
      else
        format.html { render :new }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feeds/1
  # PATCH/PUT /feeds/1.json
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: 'Feed was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:title, :description, :pic, :status, :details,:is_article)
    end
end
