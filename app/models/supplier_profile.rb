class SupplierProfile < Profile
  belongs_to :supplier

  validates :last_name, :first_name, :company_name, :department, :position, presence: true
end