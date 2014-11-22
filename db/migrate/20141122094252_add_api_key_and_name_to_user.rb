class AddApiKeyAndNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :api_key, :string
    add_column :users, :name, :string
  end
end
