require 'yaml'

class CheckAuthorization

  attr_accessor :scope

  def initialize(account, service, scope)
    @account = account
    @scope = scope
    @service = service
  end

  # Checks if there is an authorization for which the given account and/or scope
  # are authorized.
  def check
    service = config['services'].detect { |a| a['name'] == @service }
    return false unless service

    account = service['accounts'].detect { |a| a['name'] == @account }
    return false unless account

    # Return true if no scope is provided (e.g. for a login request). We can
    # only check if the service and the account exist.
    return true unless scope

    account['authorizations'].one? do |a|
      namespace_matches?(a['namespace']) &&
        image_matches?(a['image']) &&
        actions_allowed?(a['actions'])
    end
  end

  def config
    @config ||= YAML::load(File.open('authorization.yml'))
  end

  def namespace_matches?(other_namespace)
    return true unless scope.namespace
    scope.namespace == other_namespace
  end

  def image_matches?(other_image)
    return true if other_image == '*'
    scope.image == other_image
  end

  def actions_allowed?(other_actions)
    scope.actions.all? { |action| other_actions.include? action }
  end

end
