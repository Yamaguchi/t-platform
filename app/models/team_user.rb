# frozen_string_literal: true

class TeamUser < Entity
  belongs_to :team
  belongs_to :user
end
