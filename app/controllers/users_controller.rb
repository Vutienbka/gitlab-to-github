class UsersController < ApplicationController
	before_action :authenticate_user!
	
	def sample_input
	end

	def batch_items_selector
	end
end
