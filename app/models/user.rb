class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  acts_as_paranoid

  PARAMS_ATTRIBUTES = [
    :email, :password, :password_confirmation,
    :accept_flg, :antiforce_flg, :access_IP, :creator, :updater,
    profile_attributes: [
      :id, :first_name, :last_name, :tel, :company_name, :logo,
      :department, :position, :creator, :contract_status, :updater
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
