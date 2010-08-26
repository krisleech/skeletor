class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  extend Qcore::Authorization
  extend Qcore::Authentication

  qcore_autherization
  qcore_authentication

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
end
