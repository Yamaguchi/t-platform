# frozen_string_literal: true

class RoleEntityPrivilege < Entity
  belongs_to :role
  belongs_to :entity_privilege
end
