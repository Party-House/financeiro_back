class CreateBankAccount < ActiveRecord::Migration[5.1]
  def up
    create_table :bank_accounts do |t|
      t.string :account
      t.string :agency
      t.string :cpf
      t.string :agency
      t.integer :user_id, :null=>false, :references => [:users, :id]
      t.timestamps
    end
  end

  def down
    drop_table :bank_accounts
  end
end
