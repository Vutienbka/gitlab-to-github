class Buyer < User
  has_one :profile, class_name: 'BuyerProfile', dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :inspection_requests

  accepts_nested_attributes_for :profile
end

