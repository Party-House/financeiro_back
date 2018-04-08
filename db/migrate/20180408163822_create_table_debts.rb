class CreateTableDebts < ActiveRecord::Migration[5.1]
  def up
    create_table :debts do |t|
      t.decimal :debt_value, :null=>false
      t.decimal :paid, :null=>false
      t.integer :user_id, :null=>false, :references => [:users, :id]
      t.timestamps
    end
  end

  def down
    drop_table :debts
  end
end
