class Transfer < ActiveRecord::Base
  has_one :payer, :class_name=>"User"
  has_one :receiver, :class_name=>"User"
end