# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [0.7.0] - 2016-12-15

### Changed

- environment variable `RANCHER_URL` now must be set to environment url, i.e. `http://<rancher host>/v1/projects/1a9`

## [0.6.0] - 2016-12-14

### Changed

- update `Rancher::Api::Machine` model to use collection path that has `project_id` as part of url, i.e. `/v1/projects/1a5/machines/1ph1` instead of `/v1/machines/1ph1`. It seems like Rancher 1.2 forces you to use full path instead of supplying `project_id` as parameter


## [0.5.2] - 2016-08-22

- adding models for registry and registrycredentials

## [0.5.1] - 2016-08-16

- bugfix in model helpers #handle_response when handling collections

## [0.5.0] - 2016-08-10

- added few helpers:
    - #wait_for_state - waiting (EM looping) until a desired state is reached
    - #reload - reloading of resources
    - #run - run actions (custom posts)

## [0.4.0] - 2016-07-14

- update dependencies to work with Rails 5
- update README.md

## [0.3.8] - 2016-03-15

- add Ipaddress class and association to Host class

## [0.3.7] - 2016-03-15

- fix an issue with RANCHER_URL env variable (append `/v1/` to the RANCHER_URL env variable if it exists). This way RANCHER_URL becomes truly `rancher-compose`-compatible.

## [0.3.6] - 2016-03-15
### Added

- VMware vSphere driver support
- abillity to configure Rancher::Api using `rancher-compose`-compatible environment variables

