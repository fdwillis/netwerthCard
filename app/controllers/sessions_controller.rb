class SessionsController < Devise::SessionsController
  after_action :after_login, :only => :create
  before_action :after_logout, :only => :destroy

  def pullPayouts
    paymentIntents = []
    investedAmountRunning = 0
    validPaymentIntents = Stripe::PaymentIntent.list(limit: 100)['data'].map{|d| (!d['metadata']['percentToInvest'].blank?) ? (paymentIntents.append(d)) : next}

    paymentIntents.reject{|e| e['charges']['data'][0]['refunded'] == true}.reject{|e| e['charges']['data'][0]['captured'] == false}.each do |payint|
      if !payint['metadata'].blank? && payint['metadata']['percentToInvest'].to_i > 0 
        amountForDeposit = payint['amount'] - (payint['amount']*0.029).to_i + 30
        investedAmount = amountForDeposit * (payint['metadata']['percentToInvest'].to_i * 0.01)
        investedAmountRunning += investedAmount
      end
    end

    pullPayouts = []
    @amountInvested = investedAmountRunning
    topups = Stripe::Topup.list({limit: 100})['data'].map{|d| (!d['metadata']['startDate'].blank? && !d['metadata']['endDate'].blank?) ? (pullPayouts.append(d)) : next}.compact.flatten
    @topUpSum = topups.map(&:amount).sum
  end
  
  def setSessionVar
    begin
      if setSessionVarParams[:phone]
        session[:phone] = setSessionVarParams[:phone]
        session[:name] = setSessionVarParams[:name]
        session[:email] = setSessionVarParams[:email]
        session[:gender] = setSessionVarParams[:gender]
        session[:size] = setSessionVarParams[:size]

        session[:address] = {
          line1: setSessionVarParams[:line1],
          line2: setSessionVarParams[:line2],
          city: setSessionVarParams[:city],
          state: setSessionVarParams[:state],
          postal_code: setSessionVarParams[:postal_code],
          country: setSessionVarParams[:country],
        }
      end

      if setSessionVarParams[:coupon] == 'clear'
        session[:coupon] = nil
        session[:percentOff] = nil
      elsif setSessionVarParams[:coupon] && couponFound = Stripe::Coupon.retrieve(setSessionVarParams[:coupon].delete(" "), stripe_account: ENV['connectAccount'])
        session[:coupon] = setSessionVarParams[:coupon]
        session[:percentOff] = couponFound['percent_off']
        flash[:success] = "Coupon Applied"
      else
        flash[:success] = "Information Saved"
      end

      redirect_to request.referrer
    rescue Stripe::StripeError => e
      flash[:error] = e.error.message
      redirect_to request.referrer
      return
    rescue Exception => e
      flash[:error] = e
      redirect_to request.referrer
      return
    end
  end
  
  def after_logout
    logoutAtt = current_user.deleteUserSessionAPI
    
    if logoutAtt['success']
      reset_session
      current_user = nil
      flash[:success] = "See ya later"
      redirect_to root_path
    end
  end

  def after_login
    response = resource.createUserSessionAPI(params[:user])
    
    if response['success']
      flash[:success] = "Welcome"
    else
      reset_session
      current_user = nil
      flash[:error] = response["message"]
    end
  end

  private

  def setSessionVarParams
    paramsClean = params.require(:setSessionVar).permit(:name, :email, :coupon, :phone, :line1, :line2, :city, :state, :postal_code, :country, :gender, :size)
    return paramsClean.reject{|_, v| v.blank?}
  end
end