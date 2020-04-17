# frozen_string_literal: true

class Buyers::ItemDrawingsController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create edit update]
  before_action :set_item_drawing, only: %i[create edit update]

  def new
    @item_drawing = ItemDrawing.find_or_create_by(item_request_id: @item_request&.id)

    if @item_drawing.draw_categories.blank?
      DrawCategory::TYPES.each do |name|
        @item_drawing.draw_categories.build(name: name).build_file_draw
      end
      @item_drawing.save
    end

    # TODO:: bugs dropzone create duplicate record when redirec to buyers_item_images_path
    # Maybe fix later
    @item_image = ItemImage.find_or_create_by(item_request_id: @item_request&.id)

    if @item_image.image_categories.blank?
      ImageCategory::TYPES.each do |name|
        @item_image.image_categories.build(name: name).build_file_image
      end
      @item_image.save
    end
  end

  def create
    @item_drawing.creator = current_user.id
    if @item_drawing.update(item_drawing_params)
      flash[:success] = I18n.t('create.success')
      @item_request.update_attribute(:status, 3) if ItemRequest::STATUSES[@item_request.status.to_sym] < 3
      redirect_to buyers_item_images_path(item_request_id: @item_request.id)
      # Already redirect to item_images page at my_dropzone.js
    else
      flash[:alert] = I18n.t('create.failed')
      render :new
    end
  end

  def edit
  end

  def update
    @item_drawing.updater = current_user.id
    if @item_drawing.update(item_drawing_params)
      flash[:success] = I18n.t('update.success')
      @item_request.update_attribute(:status, 3) if ItemRequest::STATUSES[@item_request.status.to_sym] < 3
      @item_request.update_attributes(updater: current_user.id)
      redirect_to edit_buyers_item_images_path(item_request_id: @item_request.id)
      # Already redirect to item_images page at my_dropzone.js
    else
      flash[:alert] = I18n.t('update.failed')
      render :edit
    end
  end

  private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])

    return redirect_to root_path, flash: {alert: I18n.t('messages.no_authenticated')} unless @item_request.present? && @item_request&.buyer_id == current_user.id
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
