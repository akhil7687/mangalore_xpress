class ProductPicture < ApplicationRecord
  belongs_to :product
  has_attached_file :pic, styles: { medium: "240x160>", thumb: "120x80>", large:"480x320>" }, default_url: "/assets/photo.jpg"
  validates_attachment_content_type :pic, content_type: /\Aimage\/.*\z/
end
