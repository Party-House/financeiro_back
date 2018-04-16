require './models/purchase'
require './models/purchase_exception'
require './models/user'
require './models/transfer'
require './models/debt'

class PurchaseService
  def addPurchase (params)
    purchase = Purchase.create params[:purchase]
    debts = Debt.joins(
      "INNER JOIN users ON users.id = debts.user_id"
      ).where(users:{deleted_at: nil})
    debts.each do | debt |
      debt.debt_value += purchase.value / debts.length
      if debt.user_id == purchase.user_id
        debt.debt_value -= purchase.value
        debt.paid += purchase.value
      end
      debt.save
    end
    begin
      if params.has_key? :exceptions
        params[:exceptions].each do | exception |
          PurchaseException.create(
            :user_id => exception,
            :purchase_id => purchase.id
          )
        end
      end
    rescue
      purchase.destroy
    end
  end

  def getPurchasesByMonth(month, year)
    result = []
    purchases = Purchase.where(
      'extract(month  from purchase_date) = ? AND
      extract(year  from purchase_date) = ?', month, year)
    purchases.each do | p |
      result << {
        :value => p.value,
        :reason => p.reason,
        :comments => p.comments,
        :user_name => p.user.name,
        :purchase_date => p.purchase_date
      }
    end
    result
  end

  def getTotalDebt()
    result = []
    users = User.where :left_house => false
    users.each do | user |
      transfered = Transfer.where(:payer_id => user.id).sum(:value)
      received = Transfer.where(:receiver_id => user.id).sum(:value)
      user_debt = Debt.where(:user_id => user.id).sum(:debt_value)
      paid = Debt.where(:user_id => user.id).sum(:paid)
      user_debt += user.initial_debt + (received - transfered)
      result << {
        :user_name => user.name,
        :user_id => user.id,
        :paid => paid,
        :debt => user_debt,
        :received => received,
        :transfered => transfered
      }
    end
    exceptions_query = PurchaseException.all
    exceptions = exceptions_query.to_a
    purchase_id = 0
    exception_users = []
    while not exceptions.empty?
      exception = exceptions.pop
      purchase_id = exception[:purchase_id]
      while exception[:purchase_id] == purchase_id
        exception_users << exception[:user_id]
        if exceptions.empty?
          break
        end
      end
      exception_count = exception_users.length
      result.each do | user |
        purchase = Purchase.find(purchase_id)
        user[:debt] -= (purchase.value) / getActiveUsersCount(users, purchase.purchase_date)
        if not exception_users.include? user[:user_id]
          user[:debt] += (purchase.value) / (getActiveUsersCount(users, purchase.purchase_date) - exception_count)
        end
      end
    end
    puts result
    result
  end

  def getActiveUsersCount(users, date)
    user_count = 0
    users.each do | u |
      if u.deleted_at.nil? or u.deleted_at >= date
        user_count += 1
      end
    end
    user_count
  end
end
