class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true 
    add_index :users, :licenseN, unique: true
  end
end
