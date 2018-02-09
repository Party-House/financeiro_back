class AddColumnBankNameBankAccount < ActiveRecord::Migration[5.1]
  def up
    add_column :bank_accounts, :bank_name, :string
  end

  def down
    remove_column :bank_accounts, :bank_name
  end
end
