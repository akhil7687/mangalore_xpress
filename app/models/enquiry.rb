class Enquiry < ApplicationRecord
  belongs_to :service_category

  def status_name
    if self.status.blank? || self.status == 0
      return "NEW"
    elsif self.status == 1
      return "CLOSED"
    elsif self.status == 2
      return "REMOVED"
    end
  end
end
