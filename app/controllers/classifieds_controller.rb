class ClassifiedsController < ApplicationController
  before_action :set_classified, only: [:show, :edit, :update, :destroy,:enquire]

  def index
    if params[:category].present?
      @classifieds = Classified.with_category(params[:category])
    else
      @classifieds = Classified.order("created_at desc")
    end
    @classifieds = @classifieds.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def list
    @classifieds = Classified.all
    respond_to do |format|
      format.html
    end
  end

  def enquire
    respond_to do |format|
      format.js
    end
  end

  def show
  end

  def new
    @classified = Classified.new
  end

  def edit
  end

  def create
    @classified = Classified.new(classified_params)

    respond_to do |format|
      if @classified.save
        if user_signed_in?
          flash[:success] = "Classified successfully created."
        else
          flash[:success] = "Thank you! Our executive will look in to your ad and approve it soon!"
        end
        format.html { redirect_to classifieds_path }
        format.json { render :show, status: :created, location: @classified }
      else
        format.html { render :new }
        format.json { render json: @classified.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @classified.update(classified_params)
        format.html { redirect_to classifieds_path, notice: 'Classified was successfully updated.' }
        format.json { render :show, status: :ok, location: @classified }
      else
        format.html { render :edit }
        format.json { render json: @classified.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @classified.destroy
    respond_to do |format|
      format.html { redirect_to service_categories_url, notice: 'Classified was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
  def set_classified
    @classified = Classified.find(params[:id])
    @context = @classified
  end

  def classified_params
    params.require(:classified).permit(:title,:description,:classified_category_id,:status,:pic,:phone)
  end
end
