class Api::V1::ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
end
