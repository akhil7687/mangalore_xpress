class Store < ApplicationRecord
  has_attached_file :store_logo, styles: { medium: "240x160>", thumb: "120x80>", large:"480x320>" }, default_url: "/assets/photo.jpg"
  validates_attachment_content_type :store_logo, content_type: /\Aimage\/.*\z/

  has_many :products

  def as_json
  	super(:only=>[:id,:name,:description,:enable],:methods=>[:logo_url])
  end

  def logo_url
    "#{URI.join(ActionController::Base.asset_host,self.store_logo.url(:original))}"
  	
  end
end
