class InspectionRequest < ApplicationRecord
  extend Enumerize
  belongs_to :user, class_name: "Buyer", foreign_key: "buyer_id", optional: true

  validates :inspect_address, :inspect_tel, :inspect_company_name, :request_type,presence: true

  REQUEST_TYPES = {
    'ordinary': 1,
    'limited': 2,
    'super': 3,
  }

  enumerize :request_type, in: REQUEST_TYPES, predicates: { prefix: true }
end
