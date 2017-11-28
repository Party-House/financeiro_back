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
