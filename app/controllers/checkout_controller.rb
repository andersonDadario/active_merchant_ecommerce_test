class CheckoutController < ApplicationController
	def index
	end

	def charge
		# Use the Mondido test servers
		ActiveMerchant::Billing::Base.mode = :test

		# Config
		gateway = ActiveMerchant::Billing::MondidoGateway.new(
            :merchant_id => "", 	# Int or String - doesn't matter
            :api_token => "", 		# String
            :hash_secret => "" 		# String
		)

		# ActiveMerchant accepts all amounts as Integer values in cents
		amount = 1000  # $10.00

		# The card verification value is also known as CVV2, CVC2, or CID
		credit_card = ActiveMerchant::Billing::CreditCard.new(
		                :first_name         => 'Bob',
		                :last_name          => 'Bobsen',
		                :number             => '4111111111111111',
		                :month              => '8',
		                :year               => Time.now.year+1,
		                :verification_value => '200')

		options = {
			# One successful submission per order_id is allowed
			# Need to change after successful purchase
			:order_id => 1234
		}

		# Validating the card automatically detects the card type

		if credit_card.validate.empty?
		  # Capture $1 from the credit card
		  response = gateway.purchase(amount, credit_card, options)

		  if response.success?
		    render body: "Successfully charged $#{sprintf("%.2f", amount / 100)} to the credit card #{credit_card.display_number}"
		  else
		    raise StandardError, response.message
		  end
		end
	end
end
