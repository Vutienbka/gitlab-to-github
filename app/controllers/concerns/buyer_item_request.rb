# frozen_string_literal: true

module BuyerItemRequest
  extend ActiveSupport::Concern

  def set_item_request
    @item_request = current_user.item_requests.find_by(id: params[:id]) if current_user.buyer?
    redirect_to root_path, flash: { alert: I18n.t('messages.no_authenticated') } if @item_request.blank?
  end

  def get_count
    ItemRequest.left_outer_joins(:item_info, :item_quality, :item_drawing, :item_image, :item_standard, :item_conditions)
    .where(id: @item_request.id).group(:id).pluck("count(item_info.id) + count(item_qualities.id) + count(item_drawings.id)
     + count(item_images.id) + count(item_standards.id) + count(item_conditions.id)").first
  end
end
