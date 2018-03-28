class RealEstateRequirement < ApplicationRecord
  after_create :create_enquiry

  def create_enquiry
    e = Enquiry.new
    e.user_name = self.name
    e.user_email = self.email
    e.user_phone = self.phone
    e.status = 0
    e.enquiryable = self
    e.save
  end

  def format_property_detail
    if self.property_type == 'Other'
      return ""
    end
    return self.property_detail
  end

  def description
    "#{self.property_type} - #{self.format_property_detail} - #{self.pref_area} -#{self.budget} - #{self.remarks}"
  end
end
