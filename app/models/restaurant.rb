require 'open-uri'

class Restaurant < ActiveRecord::Base
  attr_accessible :address, :latitude, :longitude, :name
  has_many :specials
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  def self.download
    
    days = { "Monday"    => 1,
    				 "Tuesday"   => 2, 
    				 "Wednesday" => 3, 
    				 "Thursday"  => 4, 
    				 "Friday"    => 5, 
    				 "Saturday"  => 6, 
    				 "Sunday"    => 7 }

    neighborhood = "Lincoln%20Park"

    days.keys.each do |day|


	    doc = Nokogiri::HTML(open("http://www.smalltabs.com/sort.php?day=#{day}&neighborhood=#{neighborhood}"))

	    doc.css('a.special').each do |block|
	    	@blockname = ""
	    	@blockaddr = ""
	    	@blockfood = ""
	    	@blockdrink = ""
	    	@blockevent = ""
	      block.css('h3').each { |item| @blockname = item.content }
	      block.css('p.meta').each do |item| 
	      	@blockaddr = item.content.split('@').reverse.join(', ').strip
	      	@blockaddr << ", Chicago, IL"
	      end
	      block.css('li.food').each { |item|   @blockfood  = item.content }
	      block.css('li.drink').each { |item|  @blockdrink = item.content }
	      block.css('li.events').each { |item| @blockevent = item.content }


	      restaurant = Restaurant.find_by_name(@blockname) || Restaurant.create(name: @blockname, address: @blockaddr)
	      if special = Special.find_by_restaurant_id_and_day(restaurant.id, days[day])
	      	special[food:  @blockfood, 
	      				 drink: @blockdrink, 
	      				 event: @blockevent]
	      else
	    		Special.create(food:  @blockfood, 
	    				 drink: @blockdrink, 
	    				 event: @blockevent, 
	    				 restaurant_id: restaurant.id,
	    				 day: days[day])
	    	end
	    end
	  end
  end
end
