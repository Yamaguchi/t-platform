# frozen_string_literal: true

module Owner
  extend ActiveSupport::Concern

  included do
    belongs_to :owner, class_name: 'User', optional: true
  end
end
