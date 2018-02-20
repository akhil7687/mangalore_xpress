class ClassifiedCategoriesController < ApplicationController
  before_action :set_classified_category, only: [:show, :edit, :update, :destroy]

  # GET /service_categories
  # GET /service_categories.json
  def index
    @classified_categories = ClassifiedCategory.all
  end

  def autocomplete
    render json: ClassifiedCategory.where("enable=1").order('name asc').map { |contact| {:name => contact.name} }
  end

  # GET /service_categories/1
  # GET /service_categories/1.json
  def show
  end

  # GET /service_categories/new
  def new
    @classified_category = ClassifiedCategory.new
  end

  # GET /service_categories/1/edit
  def edit
  end

  # POST /service_categories
  # POST /service_categories.json
  def create
    @classified_category = ClassifiedCategory.new(classified_category_params)

    respond_to do |format|
      if @classified_category.save
        format.html { redirect_to classified_categories_path, notice: 'Classified category was successfully created.' }
        format.json { render :show, status: :created, location: @classified_category }
      else
        format.html { render :new }
        format.json { render json: @classified_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_categories/1
  # PATCH/PUT /service_categories/1.json
  def update
    respond_to do |format|
      if @classified_category.update(classified_category_params)
        format.html { redirect_to classified_categories_path, notice: 'Classified category was successfully updated.' }
        format.json { render :show, status: :ok, location: @classified_category }
      else
        format.html { render :edit }
        format.json { render json: @classified_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_categories/1
  # DELETE /service_categories/1.json
  def destroy
    @classified_category.destroy
    respond_to do |format|
      format.html { redirect_to classified_categories_url, notice: 'Classified category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classified_category
      @classified_category = ClassifiedCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def classified_category_params
      params.require(:classified_category).permit(:name)
    end
end
