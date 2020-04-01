# frozen_string_literal: true

class Buyers::ItemDrawingsController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create]

  def new
    @item_drawing = ItemDrawing.find_or_create_by(item_request_id: @item_request&.id)

    if @item_drawing.draw_categories.blank?
      DrawCategory::TYPES.each do |name|
        @item_drawing.draw_categories.build(name: name).build_file_draw
      end
      @item_drawing.save
    end
  end

  def create
    @item_drawing = ItemDrawing.find_by(item_request_id: params[:item_drawing][:item_request_id])

    if @item_drawing.update(item_drawing_params)
      flash[:success] = I18n.t('create.success')
      @item_drawing.item_request.request&.update(request_status: Request::REQUEST_STATUSES[:image])
      redirect_to input_items_image_users_path(item_request_id: params[:item_drawing][:item_request_id]) # Already redirect to input_items_image page at my_dropzone.js
      # TODO:: change path to buyer
    end
  end

  private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
  end

  def item_drawing_params
    DrawCategory::TYPES.each_with_index do |key, index|
      if params.dig(:item_drawing, :draw_categories_attributes, index.to_s, :file_draw_attributes, :file_link)
        params[:item_drawing][:draw_categories_attributes][index.to_s][:file_draw_attributes][:file_link] = params[:item_drawing][:draw_categories_attributes][index.to_s][:file_draw_attributes][:file_link].values
      end
    end

    params.require(:item_drawing).permit(ItemDrawing::PARAMS_ATTRIBUTES)
  end
end
