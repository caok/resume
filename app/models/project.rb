class Project < ActiveRecord::Base
  belongs_to :user
  attr_accessible :from, :introduction, :name, :to, :url
end
