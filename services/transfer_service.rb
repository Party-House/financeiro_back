require './models/transfer'

class TransferService
  def addTransfer (params)
    transfer = Transfer.create params
  end
end