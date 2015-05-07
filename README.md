Authorization server for version 2 of the Docker registry API.

**NOTE** Work in progress, untested.

## Getting started

Start the server using:

```
$ TOKEN_ISSUER=auth.example.com PRIVATE_KEY_PATY=<private-key-path> bundle exec ruby server.rb
```

Using the default authorizations perform the following request:

```
$ curl -X GET http://0.0.0.0:4567/v2/token?service=registry.example.com&scope=repository:foo/bar:pull&account=bob
```

The authorization will now return a token that can be used to access the
registry:

```
{"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IktCQ046U1pOVjpXVU42OjZUN1k6WUxPNDpXUkxFOldFTUU6UEhUVzpESlBUOktWQ0M6SkxCNTpHTk1EIn0.eyJpc3MiOiJhdXRoLml0cnAudmFncmFudC5sb2NhbCIsInN1YiI6ImJvYiIsImF1ZCI6InJlZ2lzdHJ5LmZvby5jb20iLCJleHAiOjE0MzEwMjk5MjYsIm5iZiI6MTQzMTAyOTYyNiwiaWF0IjoxNDMxMDI5NjI2LCJqdGkiOiJ4bkphSFc5UG5QUEtUL1JobGF1NzlRMVJQQzRFN2RoU2hTZ2xEaDJoWWkzYnBtZTZDUzJ4L1FrcSIsImFjY2VzcyI6W3sidHlwZSI6InJlcG9zaXRvcnkiLCJuYW1lIjoiZm9vL2JhciIsImFjdGlvbnMiOlsicHVsbCJdfV19.Uqkg7yknU9v57dQpf3y4iXoTrBg00XxoQhrj15XoDGPJVxOTGqG_hlCGwlflyFuMpr8YRP7g9sPxZoOirA8u3GPYWcNxnYbxWQNS0N0C9_0PTT4IF9X-E07YmS0x0hAentVRwAwDm_hCA0J0FXf_-LZMUX95QMooAoX_i1nWCvDpwZcvOuqTT6xP1dDUy_jvGcgu42DiCCND3Y04gp-Bcm70TQbdgH0_K5lj_xSc_GEllJDPutX78P59P9RJVEDAROviPnn9RnG_whowL5Kifp8CpvjWxvo41z7fHB5XN5C5dt6pMgkTQrIUy8CnoMF7hJLARz3KEoM0xir2h_UIsQ"}
```


## Configuration

### Authorization server

The following environment variables are required when running the server:

* `TOKEN_ISSUER`: The issuer of the token, typically the fqdn of the authorization server.
* `PRIVATE_KEY_PATH`: Path to private key which was used to sign the token.

### Authorizations

The `authorization.yml` contains a list of accounts and the repositories that
they have access to.

**TODO** Add some examples.

### Registry

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

The `auth.token.issuer` setting should match the `TOKEN_ISSUER` variable used in
the authorization server.

See https://github.com/docker/distribution/blob/master/docs/configuration.md#auth
for more information on configuring the registry.


## Development

**TODO** Add specs, etc.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
