class ClassifiedsController < ApplicationController
  before_action :set_classified, only: [:show, :edit, :update, :destroy]

  def index
    @classifieds = Classified.all
    respond_to do |format|
      format.html
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
        format.html { redirect_to @classified, notice: 'Classified successfully created.' }
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
        format.html { redirect_to @classified, notice: 'Classified was successfully updated.' }
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
  end

  def enquiry_params
    params.require(:classified).permit(:title,:description,:classified_category_id,:status,:pic)
  end
end
