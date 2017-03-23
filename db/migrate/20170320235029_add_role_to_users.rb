# add role column to users
class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string
  end
end
