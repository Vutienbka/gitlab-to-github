class Buyers::ItemDrawingsController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create]

  def new
  end

  def create
  end

  private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
  end
end
