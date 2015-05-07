class Scope

  attr_accessor :namespace,
                :image,
                :actions

  # Parses a String into an authorization scope.
  #
  # scope - a String containing an authorization scope in the following format:
  #         `repository:<namespace>/<image>:<actions>`
  #
  # Returns a new Scope.
  def self.parse(scope)
    repository = scope.split(':')[1]
    namespace, image = if repository.include?('/')
                         repository.split('/')
                       else
                         [nil, repository]
                       end
    actions = scope.split(':')[2].split(',')
    self.new(namespace, image, actions)
  end

  def initialize(namespace, image, actions)
    @namespace = namespace
    @image = image
    @actions = actions
  end

  def to_s
    "repository:#{repository}:#{actions.join(',')}"
  end

  def repository
    return image unless namespace
    "#{namespace}/#{image}"
  end

end
