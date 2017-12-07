class CreateTableTransfers < ActiveRecord::Migration[5.1]
  def up
    create_table :transfers do |t|
      t.decimal :value, :null=>false
      t.integer :payer_id, :null=>false, :references => [:users, :id]
      t.integer :receiver_id, :null=>false, :references => [:users, :id]
      t.timestamps
    end
  end

  def down
    drop_table :transfers
  end
end
