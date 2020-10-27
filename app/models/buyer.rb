class Buyer < User
  has_one :profile, class_name: 'BuyerProfile', dependent: :destroy
  has_many :item_requests, dependent: :destroy
  has_many :inspection_requests
  has_many :claims, class_name: 'Claims', dependent: :destroy
  accepts_nested_attributes_for :profile
  
end
