# frozen_string_literal: true

module BuyerItemRequest
  extend ActiveSupport::Concern

  def set_item_request
    @item_request = current_user.item_requests.find_by(id: params[:id]) if current_user.buyer?
    redirect_to root_path, flash: { alert: I18n.t('messages.no_authenticated') } if @item_request.blank?
  end

  def get_count
    if @item_request.status == ItemRequest.status.find_value(:submitted).value
      count = ItemRequest.status.find_value(:submitted).value
    else
    count = 0
    count += 1 if @item_request.item_info.present?
    count += 1 if @item_request.item_drawing.present? && @item_request.item_drawing&.file_specifications.present?
    count += 1 if @item_request.item_image.present? && @item_request.item_image&.file_images.present?
    count += 1 if @item_request.item_quality.present?
    count += 1 if @item_request.item_standard.present? && @item_request.item_standard&.file_inspection_criteria.present?
    count += 1 if @item_request.item_conditions.present?
    end
    count
  end
end
