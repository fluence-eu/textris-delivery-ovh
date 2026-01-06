## [Unreleased]

## [0.1.2] - 2026-01-06

### Fixed

- Fix gemspec loading by removing textris dependency from version file

## [0.1.1] - 2026-01-06

### Fixed

- Rename VERSION to API_VERSION to avoid conflict with gem version constant
- Fix Configuration mixin: use extend for class methods instead of include
- Fix superclass mismatch TypeError for class Ovh
- Add textris gem as runtime dependency

## [0.1.0] - 2026-01-05

- Initial release of textris-delivery-ovh
- OVH SMS API integration via Faraday HTTP client
- Support for OVH API authentication (application key, secret, consumer key)
- SMS delivery through OVH service
- Configuration via Rails credentials or environment variables