class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :url
      t.date :created_at
      t.date :finished_at
      t.text :introduction
      t.references :user
    end
    add_index :projects, :user_id
  end
end
