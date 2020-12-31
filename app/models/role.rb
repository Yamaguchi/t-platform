# frozen_string_literal: true

class Role < Entity
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
  has_many :entity_privileges

  def self.supported_entities
    [User, OrganizationUnit, Team, Role, EntityPrivilege]
  end
end
