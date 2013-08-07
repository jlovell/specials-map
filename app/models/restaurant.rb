require 'open-uri'

class Restaurant < ActiveRecord::Base
  attr_accessible :address, :latitude, :longitude, :name
  has_many :specials
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  def self.download
    neighborhoods = [ "Albany%20Park", 
											"Andersonville", 
											"Avondale", 
											"Bridgeport", 
											"Bucktown", 
											"Edgewater", 
											"Edison%20Park", 
											"Humboldt%20Park", 
											"Irving%20Park", 
											"Jefferson%20Park", 
											"Lakeview", 
											"Lincoln%20Park", 
											"Lincoln%20Square", 
											"Logan%20Square", 
											"Loop", 
											"Near%20North%20Side", 
											"Near%20West%20Side", 
											"Noble%20Square", 
											"North%20Center", 
											"Old%20Town", 
											"Pilsen", 
											"Printers%20Row", 
											"River%20North", 
											"Rogers%20Park", 
											"Roscoe%20Village", 
											"South%20Loop", 
											"Streeterville", 
											"Ukrainian%20Village", 
											"University%20Village", 
											"Uptown", 
											"West%20Loop", 
											"West%20Rogers%20Park", 
											"Wicker%20Park", 
											"Wrigleyville" ]

    days = { "Monday"    => 1,
    				 "Tuesday"   => 2, 
    				 "Wednesday" => 3, 
    				 "Thursday"  => 4, 
    				 "Friday"    => 5, 
    				 "Saturday"  => 6, 
    				 "Sunday"    => 7 }

    neighborhoods.each do |neighborhood|		

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
		    	sleep(0.25)
		    end
		  end
		  sleep(0.5)
		end
  end
end
