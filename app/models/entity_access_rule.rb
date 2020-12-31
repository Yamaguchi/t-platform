# frozen_string_literal: true

module EntityAccessRule
  # @param [EntityAccessContext] context
  # @return [boolean] true if entity in context has access right, otherwise false.
  def self.satisfied_by?(context)
    privileges = EntityPrivilege.joins(:role)
                                        .where(role: context.user.roles)
                                        .where(entity_name: context.entity.class.name.demodulize)
    case permission_level(privileges, context)
    when AccessLevel::GLOBAL
      context.entity.owner.organization_unit.root == context.user.owner.organization_unit.root
    when AccessLevel::DEEP
      context.user.owner.organization_unit.descendants.include?(context.entity.owner.organization_unit)
    when AccessLevel::LOCAL
      context.entity.owner.organization_unit == context.user.owner.organization_unit
    when AccessLevel::BASIC
      context.entity.owner == context.user
    when AccessLevel::NONE
      false
    end
  end

  # @param [EntityAccessQueryContext] context
  def self.select_satisfying(context, query)
    privileges = EntityPrivilege.joins(:role)
                                        .where(role: context.user.roles)
                                        .where(entity_name: context.entity_type)
    case permission_level(privileges, context)
    when AccessLevel::GLOBAL
      query.eager_load(:owner).where(users: { organization_unit_id: context.user.owner.organization_unit.root.subtree })
    when AccessLevel::DEEP
      query.eager_load(:owner).where(users: { organization_unit_id: context.user.owner.organization_unit.descendants })
    when AccessLevel::LOCAL
      query.eager_load(:owner).where(users: { organization_unit_id: context.user.organization_unit })
    when AccessLevel::BASIC
      query.where(owner: context.user)
    when AccessLevel::NONE
      query.where('1 = 0')
    end
  end

  private

  def self.permission_level(privileges, context)
    privileges.map { |p| p.access_level_of(context.access_type) }.inject(AccessLevel::NONE) do |a, b|
      AccessLevel.min(a, b)
    end
  end
end
