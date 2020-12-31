# frozen_string_literal: true

class OrganizationUnit < Entity
  has_ancestry
  has_many :users

  def contains?(organization_unit)
    descendants.contains(organization_unit)
  end
end
