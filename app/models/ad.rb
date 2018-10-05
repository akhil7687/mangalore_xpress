class Ad < ApplicationRecord
  has_attached_file :ad_img, styles: { medium: "174x152", thumb: "64x64" }, default_url: lambda { |image| ActionController::Base.helpers.asset_path('hcat3.png')}
  validates_attachment_content_type :ad_img, content_type: /\Aimage\/.*\z/


  def as_json
    super(:only=>[:id],:methods=>[:image_url])
  end

  def image_url
    "#{URI.join(ActionController::Base.asset_host,self.ad_img.url(:original))}"
  end
end
