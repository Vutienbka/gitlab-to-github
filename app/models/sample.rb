class Sample < ApplicationRecord
  belongs_to :buyer, class_name: 'Buyer', foreign_key: 'buyer_id'

  SAMPLE_TYPE = %w[similar_product color design original].freeze
  PRODUCT_CATEGORY = %w[new existing].freeze
  SAMPLE_SHAPE = %w[product plate].freeze
  DELIVERY_REQUEST = %w[courier sea_mail combine_shipping].freeze
  FUNCTION = %w[sample statndard limit].freeze
end
