class CheckoutController < ApplicationController
	def create
  	invoicesToPay = []
		
		if current_user&.authentication_token
			datax = session[:cart].to_json
			curlCall = `curl -H "Content-Type: application/json" -H "appName: #{ENV['appName']}" -H "bxxkxmxppAuthtoken: #{current_user.authentication_token}" -d '#{datax}' -X POST #{SITEurl}/v1/checkout`
			
	    response = Oj.load(curlCall)
	    
	    if response['success']
	    	session[:coupon] = nil
	    	session[:percentOff] = nil
	    	flash[:success] = "Purchase Complete"
	    	redirect_to pay_now_path
	    else
	    	flash[:error] = response['error']
	    	redirect_to carts_path
	    end
	  else
	  	begin
			  if !session[:lineItems].blank?

				  token = stripeTokenRequest(newStripeCardTokenParams)

				  if token['success']
					  connectAccountCus = stripeCustomerRequest(session, token)

					  checkoutRequest = stripeInvoiceRequest(session[:lineItems], connectAccountCus)	

					  if checkoutRequest['success']
							redirect_to request.referrer
							flash[:success] = "Purchase Complete"
						elsif checkoutRequest['error']
							redirect_to request.referrer
							flash[:error] = checkoutRequest['error']
						else
							redirect_to request.referrer
							flash[:notice] = "Smethings wrng"
						end
				  else
						redirect_to request.referrer
						flash[:error] = token['error']
				  end


					return


					
				else
					flash[:alert] = 'Add items to your cart'
					redirect_to carts_path
				end
			rescue Stripe::StripeError => e
				flash[:error] = e.error.message
				redirect_to carts_path
				return
			rescue Exception => e
				flash[:error] = e
				redirect_to carts_path
				return
			end
	  end
		
	end

	def success

		@sessionPaid = Stripe::Checkout::Session.retrieve(params[:session_id], {stripe_account: ENV['connectAccount']})

		@customerUpdated = Stripe::Customer.update(@sessionPaid.customer,{phone: session[:phone], address: session[:address]},{stripe_account: ENV['connectAccount']})

		@paymentCharge = Stripe::PaymentIntent.retrieve(@sessionPaid.payment_intent,{stripe_account: ENV['connectAccount']})

		# @paymentUpdated = Stripe::PaymentIntent.update(@sessionPaid.payment_intent,{metadata: {phone: '4144444444', address: '222 w washington madison wi 53703'}},{stripe_account: ENV['connectAccount']})
	
		@line_items = Stripe::Checkout::Session.list_line_items(@sessionPaid.id, {limit: 100}, {stripe_account: ENV['connectAccount']})['data']

		@collecctAnonFee = Stripe::Charge.create({
		  amount: @serviceFee,
		  currency: 'usd',
		  description: "#{ENV['appName']} Transaction Fee - ##{@paymentCharge.id} | TewCode",
		  source: ENV['connectAccount'],
		})

		# add anan user to platform as customer
		
		curlCall = `curl -H "Content-Type: application/json" -H "appName: #{ENV['appName']}" -X DELETE #{SITEurl}/v1/carts/#{@cartID}`

		response = Oj.load(curlCall)
	    
    if response['success']
			reset_session
    	flash[:success] = "Purchase Complete"
    else
    	flash[:error] = response['error']
    	redirect_to carts_path
    end
	end

	def cancel
		
	end
	private

	def newStripeCardTokenParams
		paramsClean = params.require(:checkout).permit(:number, :exp_year, :exp_month, :cvc)
		return paramsClean.reject{|_, v| v.blank?}
	end
end