class PaypalpermissionsController < PrivateController
  
  
  def callback    
    request_token = params[:request_token]
    verifier = params[:verification_code]
    paypal_response = permissions_gatway.get_access_token request_token, verifier
  
    if paypal_response[:ack] == 'Success'
      
      paypal_auth_info = current_user.build_paypal_auth_info
      paypal_auth_info.ppp_access_token = paypal_response[:token]
      paypal_auth_info.ppp_access_token_verifier = paypal_response[:token_secret]   
      paypal_auth_info.permissions_response = paypal_response
      paypal_auth_info.save
      
      flash[:notice] = 'You successfully added the paypal info'
      paypal_basic_data_response = permissions_gatway.get_basic_personal_data paypal_response[:token], paypal_response[:token_secret]
      paypal_auth_info.personal_data_paypal_response = paypal_basic_data_response
      
      if paypal_basic_data_response[:ack] == 'Success'
        paypal_auth_info.email = paypal_basic_data_response[:personal_data][:email]
      else
        flash[:notice] = 'An error occurred while retrieving your data from paypal, please try again'
      end
      paypal_auth_info.save
    else
      #TODO: DO we need to log this?
      flash[:notice] = 'An error occurred while accessing your paypal info'
    end    
    redirect_to "/profile"    
  end
  
  def start_request
    callback_url = URI.encode(paypalpermissions_callback_url)
    permissions = 'ACCESS_BASIC_PERSONAL_DATA,ACCESS_ADVANCED_PERSONAL_DATA'
    paypal_response = permissions_gatway.request_permissions callback_url, permissions
    
    if paypal_response[:ack] == 'Success'
      request_token = paypal_response[:token]
      session[:request_token] = request_token
      url = permissions_gatway.redirect_user_to_paypal_url(request_token)
      redirect_to url
      return
    end    
    render :text => paypal_response.inspect
  end
  
  
  private
  
  def permissions_gatway
    permissions_options = { 
                            :login => PAYPAL_API_USERNAME,
                            :password => PAYPAL_API_PASS,
                            :signature => PAYPAL_API_SIGN,
                            :app_id => PAYPAL_APP_ID
                          }
                          
    ActiveMerchant::Billing::PaypalPermissionsGateway.new(permissions_options)
  end
  
end