# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [0.3.7] - 2016-03-15

- fix an issue with RANCHER_URL env variable (append `/v1/` to the RANCHER_URL env variable if it exists). This way RANCHER_URL becomes truly `rancher-compose`-compatible.

## [0.3.6] - 2016-03-15
### Added

- VMware vSphere driver support
- abillity to configure Rancher::Api using `rancher-compose`-compatible environment variables

