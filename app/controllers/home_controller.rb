class HomeController < ApplicationController

	def nearby
		@location = { latitude: params[:latitude], longitude: params[:longitude] }
	end

	def mobile
		@location = { latitude: params[:latitude], longitude: params[:longitude] }
	end
end
