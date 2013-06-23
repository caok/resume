class Project < ActiveRecord::Base
  belongs_to :user
  attr_accessible :created_at, :introduction, :name, :finished_at, :url, :user_id
end
