class AddColumnLeftUser < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :left_house, :boolean, :default => false
  end

  def down
    remove_column :users, :left_house
  end
end
