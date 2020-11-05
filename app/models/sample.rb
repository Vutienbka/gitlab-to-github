class Sample < ApplicationRecord
  belongs_to :buyer, class_name: 'Buyer', foreign_key: 'buyer_id'
  validates :code, uniqueness: true

  SAMPLE_TYPE = %w[similar_product color design original].freeze

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
end
