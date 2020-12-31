# frozen_string_literal: true

class User < Entity
  # Include default devise modules. Others available are:
  # :omniauthable
  devise :confirmable, :database_authenticatable, :lockable, :registerable,
         :recoverable, :rememberable, :timeoutable, :trackable, :validatable
  has_many :wallets, dependent: :destroy

  has_one_attached :avatar
  
  def create_wallet(operator)
    raise PermissionDenied.new(current_user: operator, owner: self.owner, action: :update, model: self.class.to_s) unless can_update?(operator)
    wallet = Wallet.new(owner: self)
    raise PermissionDenied.new(current_user: operator, owner: self.owner, action: :create, model: wallet.class.to_s) unless wallet.can_create?(operator)
    self.wallets << wallet
    wallet
  end

  def to_s
    self.email
  end

  def primary_role
    user_roles.find_by(primary: true).role
  end

  belongs_to :organization_unit
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  after_create :assign_self

  private

  def assign_self
    reload
    update(owner: self)
  end
end
