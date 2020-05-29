class Supplier < User
  has_one :profile, class_name: 'SupplierProfile', dependent: :destroy
  has_many :item_request
  accepts_nested_attributes_for :profile
end