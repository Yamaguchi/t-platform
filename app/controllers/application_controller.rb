class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

  rescue_from PermissionDenied do |exception|
    # redirect_to root_url
  end
end
