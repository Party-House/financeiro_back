require './models/user'
require './models/bank_account'

class UserService
  def getUsers ()
    result = []
    users = User.where :left_house => false
    users.each do | p |
      result << {
        :id => p.id,
        :name => p.name
      }
    end
    result
  end

  def getBankAccounts ()
    result = []
    accounts = BankAccount.all
    accounts.each do | p |
      result << {
        :user_name => p.user.name,
        :bank_name => p.bank_name,
        :account => p.account,
        :agency => p.agency,
        :cpf => p.cpf
      }
    end
    result
  end
end