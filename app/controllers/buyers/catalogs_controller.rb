# frozen_string_literal: true

class Buyers::CatalogsController < Buyers::BaseController
  include StaticData
  before_action :get_parent_catalogs

  def index
    if params[:q].blank?
      @q = current_user&.item_requests&.ransack(params[:q])
      @item_requests = @q&.result&.page(params[:page]).per ITEM_PER_PAGE
    else
      item_sku_id = current_user&.item_requests.joins(:item_info).where('item_info.SKU like ?', "%#{params[:q][:status_cont]}%").ids
      item_name_id = current_user&.item_requests.joins(:item_info).where('item_info.name like ?', "%#{params[:q][:status_cont]}%").ids
      catalog_id = current_user&.item_requests.includes(:catalog).where(catalog_id: Catalog.where("name like ? ", "%#{params[:q][:status_cont]}%").ids).ids
      supplier_id = current_user&.item_requests.where(supplier_id: Profile.where('first_name like ? ', "%#{params[:q][:status_cont]}%").ids).ids
      ids = item_sku_id + item_name_id + catalog_id + supplier_id
      @item_requests = current_user&.item_requests.where(id: ids).includes([:item_info])

      @q = @item_requests.ransack.result.page(params[:page]).per ITEM_PER_PAGE
      render :search unless @item_requests.nil?
    end
  end

  def create
    @catalog = Catalog.new(catalog_params)
    return redirect_to buyers_catalogs_path, flash: { success: I18n.t('create.success') } if @catalog.save

    flash[:alert] = I18n.t('create.failed')
    redirect_to buyers_catalogs_path
  end

  def update
    @catalog = @catalogs.find_by(id: params[:id])
    return redirect_to buyers_catalogs_path, flash: { success: I18n.t('update.success') } if @catalog.update(name: params[:catalog][:name])
    flash[:alert] = I18n.t('update.failed')
    redirect_to buyers_catalogs_path
  end

  def destroy
    @catalog = @catalogs.find_by(id: params[:id])
    item_requests_size_of_catalog = ItemRequest.where(catalog_id: @catalog.id).size
    sub_catalog_ids = Catalog.where(parent_catalog_id: @catalog.id, level_type: "sub_catalog").ids
    item_request_size_of_sub_catalog = ItemRequest.where(catalog_id: sub_catalog_ids).size
    grandchild_catalog_ids = Catalog.where(parent_catalog_id: sub_catalog_ids, level_type: "grandchild_catalog").ids
    item_request_size_of_grandchild_catalog = ItemRequest.where(catalog_id: grandchild_catalog_ids).size

    if item_requests_size_of_catalog > 0 || item_request_size_of_sub_catalog > 0 || item_request_size_of_grandchild_catalog > 0
    return redirect_to buyers_catalogs_path, flash: { success: I18n.t('destroy.success') } if @catalog.destroy
    else
      return redirect_to buyers_catalogs_path, flash: { success: I18n.t('destroy.success') } if @catalog.really_destroy!
    end
    flash[:alert] = I18n.t('destroy.failed')
    redirect_to buyers_catalogs_path
  end

  def get_selected_catalog
    @catalog = @catalogs.find_by(id: params[:catalog_id])
    respond_to do |format|
      format.json { render json: @catalog }
    end
  end
  def get_catalog_after_click
    @catalog = Catalog.find_by(id: params[:id])
    respond_to do |format|
      format.json { render json: @catalog }
    end
  end
  private

  def get_parent_catalogs
    @catalogs = Catalog.where(level_type: 'parent', buyer_id: current_user.id)
  end

  def catalog_params
    buyer_id = current_user.id
    params.require(:catalog).permit(:name, :parent_catalog_id, :level_type).merge!(buyer_id: buyer_id)
  end
end
