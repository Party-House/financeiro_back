require './models/user'
require './models/bank_account'

user_list = [
  ["Andre", 29.38],
  ["Duilio", 38.54],
  ["Victor", -71.18],
  ["Vinicius", 0.0]
]

user_list.each do | name, debit |
  User.create(:name => name, :initial_debt => debit)
end

account_details = [
  ["8215", "18687-8", "410.007.018-05", "Andre"],
  ["7009-2", "27661-8", "323.795-128-50", "Duilio"],
  ["1945-3", "1001344-5", "411.005.748-59", "Victor"],
  ["1608", "48238-4", "443.678.618-80", "Vinicius"],
]

account_details.each do | agency, account, cpf, name |
  BankAccount.create(
    :account => agency,
    :agency => account,
    :cpf => cpf,
    :user_id => User.find_by_name(name).id
  )
end