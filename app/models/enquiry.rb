class Enquiry < ApplicationRecord
  belongs_to :enquiryable, polymorphic: true

  def status_name
    if self.status.blank? || self.status == 0
      return "NEW"
    elsif self.status == 1
      return "CLOSED"
    elsif self.status == 2
      return "REMOVED"
    end
  end

  def service_nm
    if self.enquiryable.class.name == 'ServiceCategory'
      return "Service - #{self.enquiryable.name}"
    elsif self.enquiryable.class.name == 'Classified'
      return "Classified - #{self.enquiryable.title}"
    elsif self.enquiryable.class.name == 'RealEstateRequirement'
      return "Looking For - #{self.enquiryable.description}"
    elsif self.enquiryable.class.name == 'Product'
      return "Product: #{self.enquiryable.product_desc}"
    end
  end
end
