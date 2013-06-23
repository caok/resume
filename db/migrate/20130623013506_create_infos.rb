class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.string :label
      t.string :content
      t.string :type
      t.references :user
    end
    add_index :infos, :user_id
  end
end
