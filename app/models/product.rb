class Product < ApplicationRecord
  belongs_to :store
  has_attached_file :product_image, styles: { medium: "240x160>", thumb: "120x80>", large:"480x320>" }, default_url: "/assets/photo.jpg"
  validates_attachment_content_type :product_image, content_type: /\Aimage\/.*\z/

  has_many :product_pictures

  has_many :enquiries, as: :enquiryable

  def product_desc
    "#{self.name} / Store: #{self.store.name}"
  end

  def image_url
    "#{URI.join(ActionController::Base.asset_host,self.product_image.url(:original))}"
  end

  def as_json
  	super(:only=>[:name,:description,:mrp,:price,:enable,:id],:methods=>[:image_url],:include => { :product_pictures =>{:only=>[],:methods=>[:image_path]}})
  end
end
