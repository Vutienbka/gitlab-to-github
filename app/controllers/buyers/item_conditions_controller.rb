class Buyers::ItemConditionsController < Buyers::BaseController
  before_action :redirect_to_profile
  before_action :set_item_request, only: %i[new create]
  def new
    @item_request = ItemRequest.new
    @item_request.item_conditions.build
  end
  def create
    begin
      ActiveRecord::Base.transaction do
        @item_request.update!(item_request_params)
        return redirect_to root_path, flash: { success: I18n.t('create.success') }
      rescue
        flash.now[:alert] = I18n.t('create.failed')
        render :new
      end
    end
  end

  def set_item_request
    @item_request = ItemRequest.find_by(id: params[:item_request_id])
    @item_condition = ItemCondition.find_or_initialize_by(item_request_id: @item_request.id) if @item_request.present?
  end

  def item_request_params
    params.require(:item_request).permit(ItemRequest::PARAMS_ATTRIBUTES)
  end
end