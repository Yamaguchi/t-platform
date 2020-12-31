# frozen_string_literal: true

class EntityPrivilege < Entity
  belongs_to :role

  def self.basic
    new.tap do |entity|
      entity.read_access = AccessLevel::BASIC
      entity.create_access = AccessLevel::BASIC
      entity.update_access = AccessLevel::BASIC
      entity.delete_access = AccessLevel::BASIC
    end
  end

  def self.local
    new.tap do |entity|
      entity.read_access = AccessLevel::LOCAL
      entity.create_access = AccessLevel::LOCAL
      entity.update_access = AccessLevel::LOCAL
      entity.delete_access = AccessLevel::LOCAL
    end
  end

  def self.deep
    new.tap do |entity|
      entity.read_access = AccessLevel::DEEP
      entity.create_access = AccessLevel::DEEP
      entity.update_access = AccessLevel::DEEP
      entity.delete_access = AccessLevel::DEEP
    end
  end

  def self.global
    new.tap do |entity|
      entity.read_access = AccessLevel::GLOBAL
      entity.create_access = AccessLevel::GLOBAL
      entity.update_access = AccessLevel::GLOBAL
      entity.delete_access = AccessLevel::GLOBAL
    end
  end

  def access_level_of(access_right)
    case access_right
    when AccessRight::READ
      read_access
    when AccessRight::CREATE
      create_access
    when AccessRight::UPDATE
      update_access
    when AccessRight::DELETE
      delete_access
    else
      raise 'invalid access right'
    end
  end
end
