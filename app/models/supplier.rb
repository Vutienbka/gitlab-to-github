class Supplier < User
  has_one :profile, class_name: 'SupplierProfile', dependent: :destroy
  has_many :item_request
  has_many :claims, class_name: 'Claims'
  accepts_nested_attributes_for :profile
end