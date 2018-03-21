class RealEstateRequirementsController < ApplicationController
  def create
    @real_estate_requirement = RealEstateRequirement.new(real_estate_requirement_params)
    respond_to do |format|
      if @real_estate_requirement.save
        flash[:success_enq] = "Thank you!  We will call back to you soon!"
        format.html { redirect_to :back}
      else
        format.html { rendirect_to :back }
        format.json { render json: @real_estate_requirement.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def real_estate_requirement_params
    params.require(:real_estate_requirement).permit(:name,:email,:phone,:property_type,:property_detail,:remarks,:pref_area,:budget)
  end
end
