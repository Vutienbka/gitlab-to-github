class Buyers::SubCatalogsController < Buyers::BaseController
  before_action :set_catalog, :set_sub_catalogs

  def index
    if params[:q].blank?
      @q = ItemRequest.ransack(params[:q])
      @item_requests = @q.result.page(params[:page]).per 10
    else
      item_sku_id = ItemRequest.joins(:item_info).where('item_info.SKU like ?', "%#{params[:q][:status_cont]}%").ids
      item_name_id = ItemRequest.joins(:item_info).where('item_info.name like ?', "%#{params[:q][:status_cont]}%").ids
      catalog_id = ItemRequest.includes(:catalog).where(catalog_id: Catalog.where("name like ? ", "%#{params[:q][:status_cont]}%").ids).ids
      supplier_id = ItemRequest.where(supplier_id: Profile.where('first_name like ? ', "%#{params[:q][:status_cont]}%").ids).ids
      ids = item_sku_id + item_name_id + catalog_id + supplier_id
      @item_requests = ItemRequest.where(id: ids).includes([:item_info])

      @q = @item_requests.ransack.result.page(params[:page]).per 10
      render :search unless @item_requests.nil?
    end
    if check_exist_of_items(@catalog).present?
      redirect_to buyers_catalog_catalog_items_path(@catalog.id)
    end
  end

  def create
    @sub_catalog = Catalog.new(sub_catalog_params)
    return redirect_to buyers_catalog_sub_catalogs_path(@catalog.id), flash: { success: I18n.t('create.success') } if @sub_catalog.save

    flash[:alert] = I18n.t('create.failed')
    redirect_to buyers_catalog_sub_catalogs_path(@catalog.id)
  end

  def update
    @sub_catalog = @sub_catalogs.find_by(id: params[:id])
    return redirect_to buyers_catalog_sub_catalogs_path(@catalog), flash: { success: I18n.t("update.success") } if @sub_catalog.update(name: params[:catalog][:name])
    flash[:alert] = I18n.t('update.failed')
    redirect_to buyers_catalog_sub_catalogs_path(@catalog)
  end

  def destroy
    @sub_catalog = @sub_catalogs.find_by(id: params[:id])
    return redirect_to buyers_catalog_sub_catalogs_path(@catalog), flash: { success: I18n.t("destroy.success") } if @sub_catalog.destroy
    flash[:alert] = I18n.t('destroy.failed')
    redirect_to buyers_catalog_sub_catalogs_path(@catalog)
  end

  def check_exist_of_items(catalog)
    ItemRequest.where(catalog_id: catalog.id)
  end

  def get_selected_sub_catalog
    @sub_catalog = @sub_catalogs.find_by(id: params[:sub_catalog_id])
    respond_to do |format|
      format.json { render json: @sub_catalog }
    end
  end
  
  private

  def set_catalog
    @catalog = Catalog.find_by(id: params[:catalog_id])
  end

  def set_sub_catalogs
    @sub_catalogs = @catalog.catalogs.where(level_type: 'sub_catalog')
  end

  def sub_catalog_params
    params.require(:sub_catalog).permit(:name, :parent_catalog_id, :level_type)
  end
end
