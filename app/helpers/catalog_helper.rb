# frozen_string_literal: true

module CatalogHelper
  def get_size_catalog(catalog)
    Catalog.where(parent_catalog_id: catalog.id)&.size
  end
  
  def get_size_item(catalog)
    ItemRequest.where(catalog_id: catalog.id, status: ItemRequest.status.find_value(:submitted).value)&.size
  end

end
