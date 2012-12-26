class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :flickr_id
      t.string :title
      t.text :description
      t.text :taglist
      t.boolean :is_family
      t.boolean :is_friend
      t.boolean :is_public
      t.string :thumb_url
      t.boolean :is_hidden, :default => false
      t.integer :user_id
      t.timestamps
    end
  end
end
