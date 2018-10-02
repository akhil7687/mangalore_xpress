class Product < ApplicationRecord
  belongs_to :store
  has_attached_file :product_image, styles: { medium: "240x160>", thumb: "120x80>", large:"480x320>" }, default_url: "/assets/photo.jpg"
  validates_attachment_content_type :product_image, content_type: /\Aimage\/.*\z/

  has_many :product_pictures
end
