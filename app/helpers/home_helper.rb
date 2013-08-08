module HomeHelper
	def nonempty(thing)
		if defined? thing
			if !thing.empty?
				true
			end
		end
	end
end
