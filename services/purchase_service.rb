require './models/purchase'
require './models/purchase_exception'
require './models/user'
require './models/transfer'

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
      paid = Purchase.where(:user_id => user.id).sum(:value)
      transfered = Transfer.where(:payer_id => user.id).sum(:value)
      received = Transfer.where(:receiver_id => user.id).sum(:value)
      debt = (total_expenses / user_count) - paid + user.initial_debt
      debt += (received - transfered)
      result << {
        :user_name => user.name,
        :user_id => user.id,
        :paid => paid,
        :debt => debt,
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
        user[:debt] -= (Purchase.find(purchase_id).value) / user_count
        if not exception_users.include? user[:user_id]
          puts (Purchase.find(purchase_id).value) / (user_count - exception_count)
          user[:debt] += (Purchase.find(purchase_id).value) / (user_count - exception_count)
        end
      end
    end
    result
  end
end
