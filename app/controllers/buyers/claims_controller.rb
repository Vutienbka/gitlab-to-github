# frozen_string_literal: true

class Buyers::ClaimsController < Buyers::BaseController
  before_action :redirect_to_profile
  def index; end

  def input; end

  def table; end

  def info; end

  def auto_display_name
    item_info = ItemInfo.find_by_SKU(params[:claim_item_code])
    render json: item_info
  end
  def list_item_info
    item_info_list = ItemInfo.all
    render json: item_info_list
  end
end
