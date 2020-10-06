class Buyers::SubCatalogsController < Buyers::BaseController
  before_action :set_catalog, :set_sub_catalogs

  def index
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

  def check_exist_of_items(catalog)
    ItemRequest.where(catalog_id: catalog.id)
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
