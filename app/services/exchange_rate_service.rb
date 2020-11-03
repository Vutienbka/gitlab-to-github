require 'net/http'
require 'json'
class ExchangeRateService
	def initialize(base_exchange, exchange_to)
			@exchange_to = exchange_to
			@base_exchange = base_exchange
	end
	def call
			url = "https://v6.exchangerate-api.com/v6/56234067c9a5fd8b029ce356/latest/"+ @base_exchange
			uri = URI(url)
			response = Net::HTTP.get(uri)
			response_obj = JSON.parse(response)
			rate = response_obj['conversion_rates'][@exchange_to]
	end
end
