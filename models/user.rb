class User < ActiveRecord::Base
  has_many :purchase
  has_one :bank_account
end