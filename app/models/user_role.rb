# frozen_string_literal: true

class UserRole < Entity
  belongs_to :role
  belongs_to :user
end
