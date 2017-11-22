class CreateTablePurchases < ActiveRecord::Migration[5.1]
  def up
    create_table :purchases do |t|
      t.decimal :value
      t.string :reason
      t.string :comments
      t.date :purchase_date
      t.boolean :is_durable
      t.integer :user_id, :null=>false, :references => [:users, :id]
      t.timestamps
    end
  end

  def down
    drop_table :purchases
  end
end
