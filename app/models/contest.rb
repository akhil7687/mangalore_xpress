class Contest < ApplicationRecord
  has_attached_file :pic, styles: { medium: "174x152", thumb: "64x64" }, default_url: lambda { |image| ActionController::Base.helpers.asset_path('hcat3.png')}
  validates_attachment_content_type :pic, content_type: /\Aimage\/.*\z/
  has_many :contest_registrations
end
