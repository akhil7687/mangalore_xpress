class Feed < ApplicationRecord
  has_attached_file :pic, styles: { medium: "174x152", thumb: "64x64", large: "320x240>" }, default_url: lambda { |image| ActionController::Base.helpers.asset_path('hcat3.png')}
  validates_attachment_content_type :pic, content_type: /\Aimage\/.*\z/
end
