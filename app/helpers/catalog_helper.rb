module CatalogHelper
    def get_size_catalog(catalog)
        @size = Catalog.where(parent_catalog_id: catalog.id)&.size
        @size
      end
end