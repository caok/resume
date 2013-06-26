class Project < ActiveRecord::Base
  belongs_to :user
  attr_accessible :created_at, :introduction, :name, :finished_at, :url, :user_id

  def happened_at
    created_at.to_s + (finished_at.blank? ? '' : ('-----' + finished_at.to_s))
  end
end
