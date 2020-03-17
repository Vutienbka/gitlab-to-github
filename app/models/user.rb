class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  acts_as_paranoid

  PARAMS_ATTRIBUTES = [
    :email, :password, :password_confirmation,
    :last_name, :first_name, :company_name, :access_IP,
    profile_attributes: [
      :contract_status
    ]
  ]

  def buyer?
    type == 'Buyer'
  end

  def supplier?
    type == 'Supplier'
  end

  def both?
    type == 'BuyerSupplier'
  end
end
