class Buyers::ItemDrawingsController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create]

  def new
    @item_drawing = ItemDrawing.find_or_initialize_by(item_request_id: @item_request.id)

    if @item_drawing.draw_categories.blank?
      draw_category_names = ['製品仕様図（2D）', '組立仕様図（2D）', '梱包仕様図（2D）',
                             '製品仕様図（3D）', '組立仕様図（3D）', '梱包仕様図（3D）']
      draw_category_names.each do |name|
        @item_drawing.draw_categories.build(name: name).file_draws.build
      end
    end
  end

  def create
    @item_drawing = ItemDrawing.find_by(item_request_id: params[:item_drawing][:item_request_id])
    if @item_drawing.blank?
      @item_drawing = ItemDrawing.new(item_drawing_params)

      if @item_drawing.save
        flash[:success] = I18n.t('create.success')
        item_request = ItemRequest.find_by(id: params[:item_drawing][:item_request_id])
        item_request.request&.update(request_status: Request::REQUEST_STATUSES[:image])

        return redirect_to input_items_image_users_path(item_request_id: params[:item_drawing][:item_request_id])
      end

      flash.now[:alert] = I18n.t('create.failed')
      render :new
    else
      @item_drawing.update(item_drawing_params)
      flash[:success] = I18n.t('create.success')
      item_request = ItemRequest.find_by(id: params[:item_drawing][:item_request_id])
      item_request.request&.update(request_status: Request::REQUEST_STATUSES[:image])

      return redirect_to input_items_image_users_path(item_request_id: params[:item_drawing][:item_request_id])
      # TODO:: For update function
    end
  end

  private

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
  end

  def item_drawing_params
    params.require(:item_drawing).permit(ItemDrawing::PARAMS_ATTRIBUTES)
  end
end
