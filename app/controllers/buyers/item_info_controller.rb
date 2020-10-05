# frozen_string_literal: true

class Buyers::ItemInfoController < Buyers::BaseController
  before_action :set_item_request
  before_action :set_item_info, except: %i[create]

  def new
    return redirect_to item_info_edit_buyers_item_request_path(@item_request) if @item_info.present?

    @item_info = @item_request.build_item_info
    @catalogs = Catalog.where(level_type: 'parent')
    @sub_catalogs = Catalog.where(level_type: 'sub_catal')
    @child_catalogs = Catalog.where(level_type: 'granchild_catal')
  end

  def sub_category
    @sub_catalogs = Catalog.where(parent_catalog_id: params[:catalog_id])
    render json: @sub_catalogs
  end

  def child_category
    @child_catalogs = Catalog.where(parent_catalog_id: params[:catalog_id])
    render json: @child_catalogs
  end

  def create
    @item_info = @item_request.build_item_info(item_info_params)
    begin
      ActiveRecord::Base.transaction do
        @item_info.creator = current_user.id
        @item_info.save
        @item_request.update_attributes(status: get_count, updater: current_user.id)
        return redirect_to item_drawings_edit_buyers_item_request_path(@item_request), flash: { success: I18n.t('create.success') }
      rescue StandardError
        flash.now[:alert] = I18n.t('create.failed')
        render :new
      end
    end
  end

  def edit
    redirect_to item_info_new_buyers_item_request_path(@item_request) if @item_info.blank?
    @item_info = @item_request.item_info
    @catalogs = Catalog.where(level_type: 'parent')
    @sub_catalogs = Catalog.where(level_type: 'sub_catalog')
    @child_catalogs = Catalog.where(level_type: 'granchild_catalog')
  end

  def update
    ActiveRecord::Base.transaction do
      @item_info.updater = current_user.id
      @item_info.update(item_info_params)
      @item_request.update_attributes(status: get_count, updater: current_user.id)
      return redirect_to item_drawings_edit_buyers_item_request_path(@item_request), flash: { success: I18n.t('update.success') }
    rescue StandardError
      flash.now[:alert] = I18n.t('update.failed')
      render :new
    end
  end

  private

  def set_item_info
    @item_info = @item_request.item_info if @item_request.present?
  end

  def item_info_params
    params.require(:item_info).permit(ItemInfo::PARAMS_ATTRIBUTES)
  end
end
