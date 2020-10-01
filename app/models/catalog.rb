# frozen_string_literal: true

class Catalog < ApplicationRecord
  has_many :catalogs, class_name: 'Catalog', foreign_key: 'parent_catalog_id'
  belongs_to :catalog, class_name: 'Catalog', optional: true, foreign_key: 'parent_catalog_id'

  validates :name, presence: true
end
