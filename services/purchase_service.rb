require './models/purchase'
require './models/purchase_exception'
require './models/user'

class PurchaseService
  def addPurchase (params)
    purchase = Purchase.create params[:purchase]
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
    total_expenses = Purchase.sum(:value)
    users = User.all
    user_count = users.length
    users.each do | user |
      user_expense = Purchase.where(:user_id => user.id).sum(:value)
      result << {
        :user_name => user.name,
        :user_id => user.id,
        :user_expense => user_expense,
        :user_debt => (total_expenses / user_count) - user_expense + user.initial_debt
      }
    end
    exceptions_query = PurchaseException.all
    exceptions = exceptions_query.to_a
    purchase_id = 0
    exception_users = []
    while not exceptions.empty?
      exception = exceptions.pop
      puts("exception")
      purchase_id = exception[:purchase_id]
      while exception[:purchase_id] == purchase_id
        exception_users << exception[:user_id]
        if exceptions.empty?
          break
        end
      end
      exception_count = exception_users.length
      result.each do | user |
        if exception_users.include? user[:user_id]
          user[:user_debt] -= (Purchase.find(purchase_id).value) / user_count
        else
          user[:user_debt] +=  (exception_count / user_count * (user_count - exception_count)) * (Purchase.find(purchase_id).value)
        end
      end
    end
    result
  end
end
