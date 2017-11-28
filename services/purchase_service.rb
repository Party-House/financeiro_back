require './models/purchase'
require './models/purchase_exception'
require './models/user'

class PurchaseService
  def addPurchase (params)
    purchase = Purchase.create params[:purchase]
    puts(params.has_key? :exceptions)
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
    users.each do | user |
      user_expense = Purchase.where(:user_id => user.id).sum(:value)
      result << {
        :user_name => user.name,
        :user_expense => user_expense,
        :user_debt => (total_expenses / 4) - user_expense + user.initial_debt
      }
    end
    result
  end
end
