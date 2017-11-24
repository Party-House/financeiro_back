require './models/purchase'
require './models/purchase_exception'

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
    Purchase.where(
      'extract(month  from purchase_date) = ? AND
      extract(year  from purchase_date) = ?', month, year)
  end
end
