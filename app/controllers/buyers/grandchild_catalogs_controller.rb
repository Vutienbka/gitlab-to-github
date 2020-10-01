class Buyers::GrandchildCatalogsController < Buyers::BaseController
  before_action :set_catalog, :set_sub_catalog, :set_grandchild_catalogs

  def index; end

  def create
    @grandchild_catalog = Catalog.new(grandchild_catalog_params)
    return redirect_to buyers_catalog_sub_catalog_grandchild_catalogs_path(@catalog, @sub_catalog), flash: { success: I18n.t('create.success') } if @grandchild_catalog.save

    flash[:alert] = I18n.t('create.failed')
    redirect_to buyers_catalog_sub_catalog_grandchild_catalogs_path(@catalog, @sub_catalog)
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
