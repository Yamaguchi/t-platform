# frozen_string_literal: true

class Entity < ApplicationRecord
  include Owner

  self.abstract_class = true

  def ==(other)
    super || (!id.nil? && self.class.table_name == other.class.table_name && self.id == other.id)
  end

  def update_by!(user, params)
    raise PermissionDenied.new(current_user: user, owner: self.owner, action: :update, model: self.class.to_s) unless can_update?(user)
    update!(params)
  end

  def save_by!(user)
    if new_record?
      raise PermissionDenied.new(current_user: user, owner: self.owner, action: :create, model: self.class.to_s) unless can_create?(user)
    else
      raise PermissionDenied.new(current_user: user, owner: self.owner, action: :update, model: self.class.to_s) unless can_update?(user)
    end
    save!
  end

  def destroy_by!(user)
    raise PermissionDenied.new(current_user: user, owner: self.owner, action: :delete, model: self.class.to_s) unless can_delete?(user)

    destroy!
  end

  def can_create?(user)
    return false unless user

    ctx = EntityAccessContext.new(self, AccessRight::CREATE, user)
    EntityAccessRule.satisfied_by?(ctx)
  end

  def can_read?(user)
    return false unless user

    ctx = EntityAccessContext.new(self, AccessRight::READ, user)
    EntityAccessRule.satisfied_by?(ctx)
  end

  def can_update?(user)
    return false unless user

    ctx = EntityAccessContext.new(self, AccessRight::UPDATE, user)
    EntityAccessRule.satisfied_by?(ctx)
  end

  def can_delete?(user)
    return false unless user

    ctx = EntityAccessContext.new(self, AccessRight::DELETE, user)
    EntityAccessRule.satisfied_by?(ctx)
  end

  def self.accessible(user)
    raise PermissionDenied.new(current_user: user, action: :read, model: self.class.to_s) unless user

    ctx = EntityAccessQueryContext.new(self.name.demodulize, AccessRight::READ, user)
    EntityAccessRule.select_satisfying(ctx, self)
  end

  def self.can_create?(user)
    new(owner: user).can_create?(user)
  end
end
