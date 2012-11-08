class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :fullname
      t.string :nsid
      t.string :oauth_token
      t.timestamps
    end
  end
end
