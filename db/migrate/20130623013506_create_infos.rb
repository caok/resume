class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.string :title
      t.string :content
      t.string :category
      t.references :user
    end
    add_index :infos, :user_id
  end
end
