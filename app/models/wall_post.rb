class WallPost < ApplicationRecord
  belongs_to :user
  has_attached_file :photo, styles: { medium: "240x160>", thumb: "120x80>", large:"480x320>" }, default_url: "/assets/photo.jpg"
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

  attr_accessor :remove_photo

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  def self.enabled
  	where("status=1").order("created_at desc")
  end
end
