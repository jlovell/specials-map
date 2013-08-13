module HomeHelper

	def has_specials?(place, day)
		if @special = place.specials.find{ |x| x[:day] == day }
			if !@special.food.empty? || !@special.drink.empty? || !@special.event.empty?
				true
			end
		end
	end
end
