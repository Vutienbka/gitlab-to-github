# frozen_string_literal: true

class Buyers::ItemDrawingsController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create edit update destroy]
  before_action :set_item_drawing, only: %i[create edit update destroy]

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
    if @item_drawing.update(item_drawing_params)
      flash[:success] = I18n.t('create.success')
      @item_request.update_attribute(:status, 3) if ItemRequest::STATUSES[@item_request.status.to_sym] < 3
      redirect_to buyers_item_images_path(item_request_id: @item_request.id)
      # Already redirect to item_images page at my_dropzone.js
    end
  end

  def edit
  end

  def update
    if @item_drawing.update(item_drawing_params)
      flash[:success] = I18n.t('update.success')
      @item_request.update_attribute(:status, 3) if ItemRequest::STATUSES[@item_request.status.to_sym] < 3
      redirect_to edit_buyers_item_images_path(item_request_id: @item_request.id)
      # Already redirect to item_images page at my_dropzone.js
    end
  end

  def destroy
    @item_drawing.destroy
    redirect_to products_path
  end
  private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])

    return redirect_to root_path, flash: {alert: I18n.t('messages.no_authenticated')} unless @item_request.present? && @item_request&.request&.buyer == current_user
  end

  def set_item_drawing
    @item_drawing = ItemDrawing.find_by(item_request_id: @item_request.id)
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
