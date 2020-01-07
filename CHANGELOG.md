# Changelog

## Unreleased

* Changed testing to circleci
* Switched Circle CI orb to v2
* Refactored hashes literals to Ruby 1.9+ format
* Removed allowed actions from resources at this is no longer necessary in Chef 12.5+
* Updated notification syntax to the modern notifies syntax
* Migrated to Github actions

## v0.1.6

* Add packages for rhel family
* Fix typo in readme (thanks @jgoldschrafe)
* Move recipe inclusion to action in provider and use run_context instead of node directly (thanks @jgoldschrafe)

## v0.1.4

* Update service resource usage

## v0.1.2

* Use ephemeral store to build configuration
* Remove default uid and gid values for cgconfig groups

## v0.0.1

* Initial release
