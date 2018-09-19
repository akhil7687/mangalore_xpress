class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, :counter_cache => true, polymorphic: true
end
