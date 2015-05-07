require 'sinatra'
require "sinatra/json"
require 'jwt'

require 'dotenv'
Dotenv.load if development?

require 'envied'
ENVied.require

set :show_exceptions, false

get '/v2/token' do
  scope = Scope.parse(params['scope'])
  service = params['service']
  account = params['account']

  # Check if the current account is authorized for given scope and service.
  authorized = CheckAuthorization.new(account, scope).check
  raise 'Not authorized' unless authorized

  json :token => GenerateJwtToken.new(account, service, scope).generate
end

# TODO: Not sure what the error code should be
error do
  "Not authorized..."
end

require_relative 'models/scope'
require_relative 'services/generate_jwt_token'
require_relative 'services/check_authorization'
