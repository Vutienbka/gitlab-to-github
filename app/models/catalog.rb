# frozen_string_literal: true

class Catalog < ApplicationRecord
  has_many :catalogs, class_name: 'Catalog', foreign_key: 'parent_catalog_id', dependent: :destroy
  belongs_to :catalog, class_name: 'Catalog', optional: true, foreign_key: 'parent_catalog_id'

  has_many :item_requests, class_name: 'ItemRequest', dependent: :destroy
  belongs_to :user, class_name: 'User', foreign_key: 'buyer_id', optional: true

  validates :name, presence: true
end
