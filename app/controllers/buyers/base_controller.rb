# frozen_string_literal: true

class Buyers::BaseController < ApplicationController
  include ProfileSetting
  include BuyerItemRequest

  before_action :authenticate_user!
  before_action :redirect_to_profile
  layout 'application'
end
