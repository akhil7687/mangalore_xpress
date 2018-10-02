class ProductPicturesController < ApplicationController

  before_action :set_product_picture, only: [:show, :edit, :update, :destroy]

  def new
    @product_picture = ProductPicture.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @product_picture = ProductPicture.new(product_picture_params)

    respond_to do |format|
      if @product_picture.save
        format.html { redirect_to product_path(@product_picture.product), notice: 'Product Image was successfully created.' }
        format.json { render :show, status: :created, location: @product_picture }
      else
        format.html { render :new }
        format.json { render json: @product_picture.errors, status: :unprocessable_entity }
      end
    end
    respond_to do |format|
      format.html
    end
  end

  def destroy
    @product = @product_picture.product
    @product_picture.destroy
    respond_to do |format|
      format.html { redirect_to product_path(@product), notice: 'Product Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    respond_to do |format|
      if @product_picture.update(product_picture_params)
        format.html { redirect_to product_path(@product_picture.product), notice: 'Product Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_picture }
      else
        format.html { render :edit }
        format.json { render json: @product_picture.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_product_picture
      @product_picture = ProductPicture.find(params[:id])
    end

    def product_picture_params
      params.require(:product_picture).permit(:pic,:product_id)
    end
end
