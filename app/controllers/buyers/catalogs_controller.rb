# frozen_string_literal: true

class Buyers::CatalogsController < Buyers::BaseController
  before_action :get_parent_catalogs

  def index; end

  def create
    @catalog = Catalog.new(catalog_params)
    return redirect_to buyers_catalogs_path, flash: { success: I18n.t('create.success') } if @catalog.save

    flash[:alert] = I18n.t('create.failed')
    redirect_to buyers_catalogs_path
  end

  private

  def get_parent_catalogs
    @catalogs = Catalog.where(level_type: 'parent')
  end

  def catalog_params
    params.require(:catalog).permit(:name, :parent_catalog_id, :level_type)
  end
end
