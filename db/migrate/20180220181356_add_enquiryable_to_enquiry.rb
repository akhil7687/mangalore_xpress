class AddEnquiryableToEnquiry < ActiveRecord::Migration[5.0]
  def change
    add_reference :enquiries, :enquiryable, polymorphic: true
  end
end
