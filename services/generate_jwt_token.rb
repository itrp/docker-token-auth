require 'base32'

class GenerateJwtToken

  attr_accessor :account,
                :service,
                :scope

  def initialize(account, service, scope)
    @account = account
    @service = service
    @scope = scope
  end

  def generate
    JWT.encode(claim, private_key, 'RS256', { 'kid' => jwt_kid })
  end

  def claim
    Hash.new.tap do |hash|
      hash['iss']    = ENVied.TOKEN_ISSUER
      hash['sub']    = account
      hash['aud']    = service
      hash['exp']    = expires_at
      hash['nbf']    = not_before
      hash['iat']    = issued_at
      hash['jti']    = jwt_id
      hash['access'] = access if scope
    end
  end

  def expires_at
    Time.now.getlocal.to_i + (5 * 60)
  end

  def not_before
    Time.now.getlocal.to_i
  end

  def issued_at
    not_before
  end

  def jwt_id
    SecureRandom.base64(42)
  end

  # Returns the private access claim specific to the Docker authorization
  # service specification.
  def access
    [
      'type' => 'repository',
      'name' => scope.repository,
      'actions' => scope.actions
    ]
  end

  # Returns the ID of the key which was to used to sign the token.
  def jwt_kid
    sha256 = Digest::SHA256.new
    sha256.update(private_key.public_key.to_der)
    payload = StringIO.new(sha256.digest).read(30)
    Base32.encode(payload).split('').each_slice(4).each_with_object([]) do |slice, mem|
      mem << slice.join
      mem
    end.join(':')
  end

  def private_key
    @private_key ||= begin
      binkey = File.binread(ENVied.PRIVATE_KEY_PATH)
      OpenSSL::PKey::RSA.new(binkey)
    end
  end

end
