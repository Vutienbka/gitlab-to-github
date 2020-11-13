class Sample < ApplicationRecord
  belongs_to :buyer, class_name: 'Buyer', foreign_key: 'buyer_id'
  belongs_to :item_request, optional: true, class_name: 'ItemRequest', foreign_key: 'item_request_id'

  has_many :patterns, dependent: :destroy
  accepts_nested_attributes_for :patterns, reject_if: :all_blank, allow_destroy: true

  SAMPLE_TYPE = %w[similar_product color design original].freeze
  SAMPLE_TYPE = %w[standard limit similar_product color design original].freeze

  PRODUCT_CATEGORY = %w[new existing].freeze

  SAMPLE_SHAPE = %w[product plate].freeze

  DELIVERY_REQUEST = %w[courier sea_mail combine_shipping].freeze

  FUNCTION = %w[sample statndard limit].freeze

  PARAMS_ATTRIBUTES = [
    :buyer_id, :item_request_id, :title, :category, :classify,
    :sample_type, :code, :quantity,
    :delivery_time, :delivery_request, :function,
    :updater, patterns_attributes: [:id, :pattern, :_destroy]
  ]

  scope :filter_by_sample_type, ->(sample_type) { where(sample_type: sample_type) if sample_type.present? }
  scope :filter_by_supplier_name, ->(supplier_name) {
          where(item_request_id: (ItemRequest.where(id: ItemRequest.includes(:samples).pluck(:item_request_id))
                  .where(supplier_id: Profile.where(company_name: supplier_name).pluck(:supplier_id))).ids) if supplier_name.present?
        }
  scope :filter_by_catalog_name, ->(catalog_name) {
      where(item_request_id: (ItemRequest.where(id: ItemRequest.includes(:samples).pluck(:item_request_id))
              .where(catalog_id: Catalog.where(name: catalog_name).ids)).ids) if catalog_name.present?
    }
  scope :search_by_supplier_name_or_code, ->(items_of_buyer, supplier_name_or_code) {
          where(item_request_id: (items_of_buyer.where(id: items_of_buyer.includes(:samples).pluck(:item_request_id))
                  .where(supplier_id: Profile.where("company_name like ?", "%#{supplier_name_or_code}%")
                           .or(Profile.where("code like ?", "%#{supplier_name_or_code}%")).pluck(:supplier_id))).ids) if supplier_name_or_code.present?
        }
  scope :search_by_sample_title_or_code, ->(samples_of_buyer, sample_title_or_code) {
          samples_of_buyer.where("title like ?", "%#{sample_title_or_code}%")
            .or(samples_of_buyer.where("code like ?", "%#{sample_title_or_code}%")) if sample_title_or_code.present?
        }

  scope :search_by_catalog_name, ->(samples_of_buyer, catalog_name) {
      where(item_request_id: (ItemRequest.where(id: ItemRequest.includes(:samples).pluck(:item_request_id))
              .where(catalog_id: Catalog.where("name like ?", "%#{catalog_name}%").ids)).ids) if catalog_name.present?
    }
end
