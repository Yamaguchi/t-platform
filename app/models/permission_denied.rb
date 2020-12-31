# frozen_string_literal: true

class PermissionDenied < StandardError
  attr_accessor :current_user, :owner, :action, :model

  def initialize(current_user:, owner:, action:, model:)
    @current_user = current_user
    @owner = owner
    @action = action
    @model = model
  end

  def to_s
    "PermissionDenied(User #{current_user} can not #{action} the #{model} owned by #{owner}.)"
  end
end
