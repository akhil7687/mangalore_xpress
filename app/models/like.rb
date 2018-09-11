class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, :counter_cache => true, polymorphic: true
  validates_uniqueness_of :likeable_id, :scope => [:likeable_type, :user_id]
end
