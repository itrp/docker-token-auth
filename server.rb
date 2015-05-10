require 'sinatra'
require "sinatra/json"
require 'jwt'

require 'dotenv'
Dotenv.load if development?

require 'envied'
ENVied.require

set :show_exceptions, false
set :bind, '0.0.0.0'

get '/v2/token/' do
  scope = Scope.parse(params['scope'])
  service = params['service']
  account = params['account']

  # Check if the current account is authorized for given scope and service.
  authorized = CheckAuthorization.new(account, service, scope).check
  halt 401 unless authorized

  json :token => GenerateJwtToken.new(account, service, scope).generate
end

error do
  "Something went wrong..."
end

require_relative 'models/scope'
require_relative 'services/generate_jwt_token'
require_relative 'services/check_authorization'
