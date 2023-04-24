class MPesasController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:callback]
    require 'rest-client'

    ## send pin push to user
    def stkpush 
        user_id = params[:user_id]
        phoneNumber = params[:phoneNumber]
        amount = params[:amount]
    

        url = "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest"
        timestamp = "#{Time.now.strftime "%Y%m%d%H%M%S"}"
        business_short_code = ENV["MPESA_SHORTCODE"]
        password = Base64.strict_encode64("#{business_short_code}#{ENV["MPESA_PASSKEY"]}#{timestamp}")
        
        payload = {
            'BusinessShortCode': business_short_code,
            'Password': password,
            'Timestamp': timestamp,
            'TransactionType': "CustomerPayBillOnline",
            'Amount': amount,
            'PartyA': phoneNumber,
            'PartyB': business_short_code,
            'PhoneNumber': phoneNumber,
            'CallBackURL': "#{ENV["CALLBACK_URL"]}/callback_url/#{user_id}",
            'AccountReference': 'Trial ROR Mpesa',
            'TransactionDesc': "ROR trial"
        }.to_json
        
        headers = {
        content_type: 'application/json', 
        Authorization:"Bearer #{get_access_token}"
        }
        response = RestClient::Request.new({
            method: :post,
            url: url,
            payload: payload,
            headers: headers
        }).execute do |response, request|
            case response.code
            when 500
            [ :error, JSON.parse(response.to_str) ]
            when 400
            [ :error, JSON.parse(response.to_str) ]
            when 200
            [ :success, JSON.parse(response.to_str) ]
            else
            fail "Invalid response #{response.to_str} received."
            end
        end
        
        render json: response
    end

    ## callback for getting mpesa results
    def callback
        # Log a simple message
        logger.info("reached callback_url")

        # Get the request body
        request_body = request.body.read

        # Parse the JSON payload
        payload = JSON.parse(request_body)

        # Extract the relevant data from the payload
        transaction_type = payload['TransactionType']
        transaction_time = payload['TransTime']
        transaction_amount = payload['TransAmount']
        transaction_reference = payload['BillRefNumber']
        transaction_sender = payload['MSISDN']
        transaction_account = payload['BusinessShortCode']
        transaction_id = payload['TransID']
        transaction_status = payload['ResultCode']

        # Process the transaction data here
        CallbackUrl.create!(user_id: user_id, trans_id: transaction_id, trans_amount: transaction_amount,
            trans_time: transaction_time, bill_ref_number: transaction_reference, msisdn: transaction_sender,
            resultcode: transaction_status, business_shortcode: transaction_account, transaction_type: transaction_type
        )
        
        # Send a response back to M-Pesa
        render plain: "Callback received successfully", status: :ok
    end

    ## private functions

    private

    def generate_access_token_request
        @url = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
    
        @consumer_key =  ENV['MPESA_CONSUMER_KEY']
        @consumer_secret = ENV['MPESA_CONSUMER_SECRET']
        @userpass = Base64::strict_encode64("#{@consumer_key}:#{@consumer_secret}")
        @headers = {
            Authorization: "Basic #{@userpass}",
            'Content-Type': 'application/json'
        }
        
        res = RestClient::Request.execute(url: @url, method: :get, headers: @headers)
        res 
    end 

    def get_access_token
        res = generate_access_token_request()
        if res.code != 200
          r = generate_access_token_request()
          if res.code != 200
           response = [ :error, JSON.parse('Unable to generate access token') ]
           render json: response
            # raise MpesaError('Unable to generate access token')
          end
        end
        body = JSON.parse(res, { symbolize_names: true })
        token = body[:access_token]
        AccessToken.destroy_all()
        AccessToken.create!(token: token)
        token   
    end 
end
