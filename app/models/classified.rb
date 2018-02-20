class Classified < ApplicationRecord
  belongs_to :classified_category

  has_attached_file :pic, styles: { medium: "174x152", thumb: "64x64" }, default_url: lambda { |image| ActionController::Base.helpers.asset_path('hcat3.png')}
  validates_attachment_content_type :pic, content_type: /\Aimage\/.*\z/

  has_many :enquiries, as: :enquiryable

  def self.with_category(category_ids)
    self.where("classified_category_id in (?)",category_ids).order("created_at desc")
  end
end
