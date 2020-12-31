# frozen_string_literal: true

class EntityAccessQueryContext
  attr_accessor :entity_type, :access_type, :user

  # @param [AccessRight] access_type
  def initialize(entity_type, access_type, user)
    @entity_type = entity_type
    @access_type = access_type
    @user = user
  end
end
