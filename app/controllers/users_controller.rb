# frozen_string_literal: true

class UsersController < ApplicationController
  include ProfileSetting

  before_action :redirect_to_profile
  before_action :authenticate_user!
  def index
    # redirect_to admins_root_path
  end

  def destroy
    # redirect_to signout_path
  end

  def sample_input; end

  def batch_items_selector; end

  def input_items_info; end

  def input_items_drawing; end

	def batch_items_selector
  end

  def input_items_image; end

  def batch_register; end

  def choose_provider
  end 

  def email_inspection
  end 

  def email_register_item
  end 

  def inspect_supplier; end

  def register_item; end

  def search_provider
  end 

  def order_list
  end

  def input_item_quality
  end 

  def cost_down_item
  end

  def status_inspect
  end 
end
