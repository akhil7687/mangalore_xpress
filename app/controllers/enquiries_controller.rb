class EnquiriesController < ApplicationController
  before_action :set_enquiry, only: [:show, :edit, :update, :destroy]
  def create
    @enquiry = Enquiry.new(enquiry_params)
    if @enquiry.user_phone.blank?
      flash[:error] = "Please enter your phone number"
      respond_to :back
      return
    end
    if @enquiry.save
      flash[:success_enq] = "Thank you! Our representative will call back to you soon!"
      redirect_to :back
    else
      flash[:error] = "Failed to create request! Please try again"
      redirect_to :back
    end
    respond_to do |format|
      format.js
      format.html
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
end
