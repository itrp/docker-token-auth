Authorization server for version 2 of the Docker registry API.

**NOTE** Work in progress, untested.

## Getting started

### Setup authorizations

The `authorization.yml` contains a list of accounts and the repositories that
they have access to.

The `authorization.yml.template` contains some examples to get started. You can
copy it to `authorization.yml` and adjust it to your own needs.

### Configure registry

The Docker registry should be configured to use token authentication using this
server. An example:

```
auth:
  token:
    realm: https://auth.docker.com/v2/token/
    service: registry.docker.com
    issuer: auth.docker.com
    rootcertbundle: <path-to-cert-bundle>
```

The `auth.token.realm` setting should be set to the url on which the
authorization can be reached. The `auth.token.issuer` setting should match the
`TOKEN_ISSUER` variable used in the authorization server.

See https://github.com/docker/distribution/blob/master/docs/configuration.md#auth
for more information on configuring the registry.

### Run Authorization server

Start the server using:

```
$ TOKEN_ISSUER=auth.example.com PRIVATE_KEY_PATY=<private-key-path> bundle exec ruby server.rb
```

### Log in to registry

Run the following command from a Docker client:

```
$ docker login registry.example.com
```

You'll need to provide a username, password and e-mail that will be stored in
the `.dockercfg` file in the current user's home directory.

The Docker client will send the following request to the authorization server:

```
GET /v2/token/?account=bob&service=registry.example.com
```

The authorization server will return a token if the user is authorized.

The same steps are performed when users perform a push or pull command on the
registry.


## Configuration

### Authorization server

The following environment variables are required when running the server:

* `TOKEN_ISSUER`: The issuer of the token, typically the fqdn of the authorization server.
* `PRIVATE_KEY_PATH`: Path to private key which was used to sign the token.

### Authorizations

**TODO** Add some examples.


## Development

**TODO** Add specs, etc.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
