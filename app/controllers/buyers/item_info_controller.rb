# frozen_string_literal: true

class Buyers::ItemInfoController < Buyers::BaseController
  before_action :set_item_request
  before_action :set_item_info, except: %i[create]

  def new
    return redirect_to item_info_edit_buyers_item_request_path(@item_request) if @item_info.present?

    @item_info = @item_request.build_item_info
    @catalogs = Catalog.where(buyer_id: current_user.id, level_type: 'parent')
    @sub_catalogs = Catalog.where(parent_catalog_id: @catalogs.ids, level_type: 'sub_catalog')
    @child_catalogs = Catalog.where(parent_catalog_id: @sub_catalogs.ids, level_type: 'grandchild_catalog')
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

        catalog = @item_request.item_info&.category1
        sub_catalog = @item_request.item_info&.category2
        grandchild_catalog = @item_request.item_info&.category3

        if grandchild_catalog.present? && grandchild_catalog.positive?
          @item_request.update_attributes(status: get_count, updater: current_user.id, catalog_id: grandchild_catalog)
          return redirect_to item_drawings_edit_buyers_item_request_path(@item_request), flash: { success: I18n.t('create.success') }
        end

        if sub_catalog.present? && sub_catalog.positive?
          @item_request.update_attributes(status: get_count, updater: current_user.id, catalog_id: sub_catalog)
          return redirect_to item_drawings_edit_buyers_item_request_path(@item_request), flash: { success: I18n.t('create.success') }
        end

        if catalog.present? && catalog.positive?
          @item_request.update_attributes(status: get_count, updater: current_user.id, catalog_id: catalog)
          return redirect_to item_drawings_edit_buyers_item_request_path(@item_request), flash: { success: I18n.t('create.success') }
        end
      rescue StandardError
        flash.now[:alert] = I18n.t('create.failed')
        render :new
      end
    end
  end

  def edit
    return redirect_to item_info_new_buyers_item_request_path(@item_request) if @item_info.blank?

    @item_info = @item_request.item_info
    @catalogs = Catalog.where(buyer_id: current_user.id, level_type: 'parent')
    @sub_catalogs = Catalog.where(parent_catalog_id: @item_info.category1, level_type: 'sub_catalog')
    @child_catalogs = Catalog.where(parent_catalog_id: @item_info.category2, level_type: 'grandchild_catalog')
  end

  def update
    ActiveRecord::Base.transaction do
      @item_info.updater = current_user.id
      @item_info.update(item_info_params)

      catalog = @item_info.category1
      sub_catalog = @item_info.category2
      grandchild_catalog = @item_info.category3

      if grandchild_catalog.present? && grandchild_catalog.positive?
        @item_request.update_attributes(status: get_count, updater: current_user.id, catalog_id: grandchild_catalog)
        return redirect_to item_drawings_edit_buyers_item_request_path(@item_request), flash: { success: I18n.t('update.success') }
      end

      if sub_catalog.present? && sub_catalog.positive?
        @item_request.update_attributes(status: get_count, updater: current_user.id, catalog_id: sub_catalog)
        return redirect_to item_drawings_edit_buyers_item_request_path(@item_request), flash: { success: I18n.t('update.success') }
      end

      if catalog.present? && catalog.positive?
        @item_request.update_attributes(status: get_count, updater: current_user.id, catalog_id: catalog)
        return redirect_to item_drawings_edit_buyers_item_request_path(@item_request), flash: { success: I18n.t('update.success') }
      end
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
