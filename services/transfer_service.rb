require './models/transfer'

class TransferService
  def addTransfer (params)
    transfer = Transfer.create params[:transfer]
  end
end