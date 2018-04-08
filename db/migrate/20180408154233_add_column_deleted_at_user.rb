class AddColumnDeletedAtUser < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :deleted_at, :date
  end

  def down
    remove_column :users, :deleted_at
  end
end
