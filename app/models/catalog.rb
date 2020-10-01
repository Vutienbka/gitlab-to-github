class Catalog < ApplicationRecord
    has_many :catalog, class_name: 'Catalog'
    belongs_to :catalog, class_name: 'Catalog', optional: true, foreign_key:'parent_catalog_id'

    validates :name, presence:true
end
