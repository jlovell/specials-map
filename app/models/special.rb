class Special < ActiveRecord::Base
  attr_accessible :day, :drink, :event, :food, :restaurant_id
  belongs_to :restaurant
end
