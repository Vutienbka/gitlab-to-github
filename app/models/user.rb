class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  acts_as_paranoid
  # has_many :user_calendars
  attr_accessor :update_profile

  PARAMS_ATTRIBUTES = [
    :email, :password, :password_confirmation, :update_profile,
    :accept_flg, :antiforce_flg, :access_IP, :creator, :updater,
    profile_attributes: [
      :id, :first_name, :last_name, :tel, :company_name, :logo,
      :department, :position, :creator, :contract_status, :updater
    ]
  ]

  has_many :user_invites, dependent: :destroy
  has_many :catalogs, dependent: :destroy
  has_many :contracts
  validates :password, confirmation: { case_sensitive: true }
  validates :password, presence: true, unless: :check_update_profile?
  validates :email, presence: true

  before_create :set_token

  def set_token
    return if check_admin?
    self.token = SecureRandom.hex
  end

  def check_admin?
    self.is_a?(Admin)
  end

  def check_update_profile?
    update_profile.present?
  end

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
