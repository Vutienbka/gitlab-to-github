class Buyers::GrandchildCatalogsController < Buyers::BaseController
  before_action :set_catalog, :set_sub_catalog, :set_grandchild_catalogs

  def index
    if params[:q].blank?
      @q = current_user&.item_requests.ransack(params[:q])
      @item_requests = @q.result.page(params[:page]).per 10
    else
      item_sku_id = current_user&.item_requests.joins(:item_info).where('item_info.SKU like ?', "%#{params[:q][:status_cont]}%").ids
      item_name_id = current_user&.item_requests.joins(:item_info).where('item_info.name like ?', "%#{params[:q][:status_cont]}%").ids
      catalog_id = current_user&.item_requests.includes(:catalog).where(catalog_id: Catalog.where("name like ? ", "%#{params[:q][:status_cont]}%").ids).ids
      supplier_id = current_user&.item_requests.where(supplier_id: Profile.where('first_name like ? ', "%#{params[:q][:status_cont]}%").ids).ids
      ids = item_sku_id + item_name_id + catalog_id + supplier_id
      @item_requests = current_user&.item_requests.where(id: ids).includes([:item_info])

      @q = @item_requests.ransack.result.page(params[:page]).per 10
      render :search unless @item_requests.nil?
    end
    if check_exist_of_items(@sub_catalog).present?
      redirect_to buyers_catalog_catalog_items_path(@sub_catalog.id)
    end
  end

  def create
    @grandchild_catalog = Catalog.new(grandchild_catalog_params)
    return redirect_to buyers_catalog_sub_catalog_grandchild_catalogs_path(@catalog, @sub_catalog), flash: { success: I18n.t('create.success') } if @grandchild_catalog.save

    flash[:alert] = I18n.t('create.failed')
    redirect_to buyers_catalog_sub_catalog_grandchild_catalogs_path(@catalog, @sub_catalog)
  end

  def update
    @grandchild_catalog = @grandchild_catalogs.find_by(id: params[:id])
    return redirect_to buyers_catalog_sub_catalog_grandchild_catalogs_path(@catalog, @sub_catalog),
    flash: { success: I18n.t('update.success') } if @grandchild_catalog.update(name: params[:catalog][:name])
    flash[:alert] = I18n.t('update.failed')
    redirect_to buyers_catalog_sub_catalog_grandchild_catalogs_path(@catalog, @sub_catalog)
  end

  def destroy
    @grandchild_catalog = @grandchild_catalogs.find_by(id: params[:id])
    item_request_size_of_grandchild_catalog = ItemRequest.where(catalog_id: @grandchild_catalog.id).size

    if item_request_size_of_grandchild_catalog > 0
      return redirect_to buyers_catalog_sub_catalog_grandchild_catalogs_path(@catalog, @sub_catalog),
      flash: { success: I18n.t('destroy.success') } if @grandchild_catalog.destroy
    else
      return redirect_to buyers_catalog_sub_catalog_grandchild_catalogs_path(@catalog, @sub_catalog),
      flash: { success: I18n.t('destroy.success') } if @grandchild_catalog.really_destroy!
    end

    flash[:alert] = I18n.t('destroy.failed')
    redirect_to buyers_catalog_sub_catalog_grandchild_catalogs_path(@catalog, @sub_catalog)
  end

  def check_exist_of_items(catalog)
    @current_user.item_requests.where(catalog_id: catalog.id)
  end

  def get_selected_grandchild_catalog
    @grandchild_catalog = @grandchild_catalogs.find_by(id: params[:grandchild_catalog_id])
    respond_to do |format|
      format.json { render json: @grandchild_catalog }
    end
  end

  private

  def set_catalog
    @catalog = Catalog.find_by(id: params[:catalog_id])
  end

  def set_sub_catalog
    @sub_catalog = @catalog.catalogs.find_by(id: params[:sub_catalog_id])
  end

  def set_grandchild_catalogs
    @grandchild_catalogs = @sub_catalog.catalogs.where(level_type: 'grandchild_catalog')
  end

  def grandchild_catalog_params
    params.require(:grandchild_catalog).permit(:name, :parent_catalog_id, :level_type)
  end
end
