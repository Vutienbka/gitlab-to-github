class Buyers::CatalogItemsController < Buyers::BaseController
  before_action :set_catalog

  def index
    @catalog_items = @catalog.item_requests
  end

  private

  def set_catalog
    @catalog = Catalog.find_by(id: params[:catalog_id])

    if @catalog.level_type.eql? 'grandchild_catalog'
      @grandchild_catalog = @catalog
      @sub_catalog = Catalog.find_by(id: @grandchild_catalog.parent_catalog_id)
      @parent_catalog = Catalog.find_by(id: @sub_catalog.parent_catalog_id)
    elsif @catalog.level_type.eql? 'sub_catalog'
      @sub_catalog = @catalog
      @parent_catalog = Catalog.find_by(id: @sub_catalog.parent_catalog_id)
    else
      @parent_catalog = @catalog
    end 
  end
end
