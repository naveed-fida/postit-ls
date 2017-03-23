class AddUserIdToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.integer :user_id
    end
    add_foreign_key :posts, :users 
  end
end
