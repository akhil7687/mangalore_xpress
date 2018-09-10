class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: lambda { |image| ActionController::Base.helpers.asset_path('photo.jpg') }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
  

  def is_admin?
  	return (self.email == "amit@mxp.com")
  end

  
  def nice_name
    return self.email.split("@").first if self.name.blank?
    if self.name.length > 20
      self.name.split(" ").first.capitalize
    else
      return self.name
    end
  end

end
