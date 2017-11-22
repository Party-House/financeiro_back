class CreateTablePurchaseExceptions < ActiveRecord::Migration[5.1]
  def up
    create_table :purchase_exceptions do |t|
      t.integer :purchase_id, :null=>false, :references => [:purchases, :id]
      t.integer :user_id, :null=>false, :references => [:users, :id]
      t.timestamps
    end
  end

  def down
    drop_table :purchase_exceptions
  end
end
