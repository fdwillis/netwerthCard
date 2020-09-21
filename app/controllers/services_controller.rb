class ServicesController < ApplicationController
	def index
		curlCall = `curl -d "" -X GET #{SITEurl}/v1/time-slots`

    response = Oj.load(curlCall)

    if !response.blank? && response['success']
			@hourlies = response['hourlies']
			@services = response['services']
			@products = response['products']
			
		else
			flash[:notice] = "Trouble connecting. Try again later."
			redirect_to new_user_session_path
		end
	end

	def show
		curlCall = `curl -X GET #{SITEurl}/v1/time-slots/#{params[:id]}`
		
		response = Oj.load(curlCall)
		
		if !response.blank? && response['success']
			@slot = response['timeSlot']
		else
			flash[:notice] = "Trouble connecting. Try again later."
		end
	end
end