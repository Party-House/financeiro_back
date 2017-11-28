class User < ActiveRecord::Base
  has_many :purchase
end