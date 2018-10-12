class EnquiriesController < ApplicationController
  before_action :set_enquiry, only: [:show, :edit, :update, :destroy]

  def create
    @context = context
    @enquiry = @context.enquiries.new(enquiry_params)

    if @enquiry.user_phone.blank?
      flash[:error] = "Please enter your phone number"
      respond_to :back
      return
    end

    if @enquiry.save
      flash[:success_enq] = "Thank you! Our representative will call back to you soon!"
    else
      flash[:error] = "Failed to create request! Please try again"
    end

    respond_to do |format|
      format.js
      format.html{ redirect_to :back }
      format.json{render :json=>{:update_status=>"success",:status=>200}}
    end
  end

  def index
    @enquiries = Enquiry.order("created_at desc")
    respond_to do |format|
      format.html
    end
  end

  def update
    respond_to do |format|
      if @enquiry.update(enquiry_params)
        format.html { redirect_to enquiries_path, notice: 'Service category was successfully updated.' }
        format.json { render :show, status: :ok, location: @enquiry }
      else
        format.html { render :edit }
        format.json { render json: @enquiry.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_enquiry
    @enquiry = Enquiry.find(params[:id])
  end

  def enquiry_params
    params.require(:enquiry).permit(:user_name,:user_email,:user_phone,:service_category_id,:status)
  end

  def context
    if params[:service_category_id]
      id = params[:service_category_id]
      ServiceCategory.friendly.find(params[:service_category_id])
    elsif params[:product_id]
      id = params[:product_id]
      Product.find(params[:product_id])
    else
      id = params[:classified_id]
      Classified.find(params[:classified_id])
    end
  end
end
