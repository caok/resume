class Info < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content, :title, :category, :user_id
end
