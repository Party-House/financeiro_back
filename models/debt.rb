class Debt < ActiveRecord::Base
  has_one :user, :class_name=>"User"
end