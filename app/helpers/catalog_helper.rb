# frozen_string_literal: true

module CatalogHelper
  def get_size_catalog(catalog)
    Catalog.where(parent_catalog_id: catalog.id)&.size
  end
end
