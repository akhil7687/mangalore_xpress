class ServiceCategory < ApplicationRecord
  has_attached_file :icon_img, styles: { medium: "300x300", thumb: "64x64" }, default_url: lambda { |image| ActionController::Base.helpers.asset_path('hcat3.png')}
  validates_attachment_content_type :icon_img, content_type: /\Aimage\/.*\z/
  has_attached_file :cover_img, styles: { large: "1286x400>", thumb: "320x240>" }, default_url: lambda { |image| ActionController::Base.helpers.asset_path('banner4.jpg')}
  validates_attachment_content_type :cover_img, content_type: /\Aimage\/.*\z/
  has_many :service_providers
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :enquiries, as: :enquiryable

  def self.enabled_services
    where("enable=1").order('name asc')
  end

  def enabled_providers
    self.service_providers.where("enable=1").order("created_at desc")
  end
end
