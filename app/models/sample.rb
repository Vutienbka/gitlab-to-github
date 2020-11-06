class Sample < ApplicationRecord
  belongs_to :buyer, class_name: "Buyer", foreign_key: "buyer_id"
  belongs_to :item_request, optional: true, class_name: "ItemRequest", foreign_key: "item_request_id"
  validates :code, uniqueness: true
  has_many :patterns, dependent: :destroy
  
  SAMPLE_TYPE = %w[similar_product color design original].freeze
  SAMPLE_TYPE = %w[standard limit similar_product color design original].freeze

  PRODUCT_CATEGORY = %w[new existing].freeze

  SAMPLE_SHAPE = %w[product plate].freeze

  DELIVERY_REQUEST = %w[courier sea_mail combine_shipping].freeze

  FUNCTION = %w[sample statndard limit].freeze

  PARAMS_ATTRIBUTES = %i[
    buyer_id title category classify
    sample_type code quantity
    delivery_time delivery_request function
    updater
  ].freeze

  scope :filter_by_sample_type, ->(sample_type) { where(:sample_type => sample_type) if sample_type.present? }
  scope :filter_by_supplier_name, ->(supplier_name) {
          where(:item_request_id => (ItemRequest.where(id: ItemRequest.includes(:samples).pluck(:item_request_id))
                  .where(supplier_id: Profile.where(company_name: supplier_name).pluck(:supplier_id))).ids) if supplier_name.present?
        }
  scope :filter_by_catalog_name, ->(catalog_name) {
          where(:item_request_id => (ItemRequest.where(id: ItemRequest.includes(:samples).pluck(:item_request_id))
                  .where(catalog_id: Catalog.where(name: catalog_name).ids)).ids) if catalog_name.present?
        }
end
