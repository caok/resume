class Info < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content, :title, :category
end
