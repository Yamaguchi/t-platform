# frozen_string_literal: true

class EntityAccessContext
  attr_accessor :entity, :access_type, :user
  # @param [AccessRight] access_type
  def initialize(entity, access_type, user)
    @entity = entity
    @access_type = access_type
    @user = user
  end
end
