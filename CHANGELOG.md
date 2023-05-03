# Changelog

## Unreleased

## 0.2.7 - *2023-05-03*

## 0.2.6 - *2023-04-01*

## 0.2.5 - *2023-03-02*

- Remove delivery workflow

## 0.2.4 - *2023-02-14*

- Remove delivery folder

## 0.2.3 - *2021-08-31*

- Standardise files with files in sous-chefs/repo-management

## v0.2.1 (2020-11-12)

- Resolved failures in the recipe / resources to find the correct helper methods

## v0.1.6 (2020-01-26)

- Convert from LWRPs to custom resources
- Properly set name properties in the resources
- Refactored hashes literals to Ruby 1.9+ format
- Removed allowed actions from resources at this is no longer necessary in Chef 12.5+
- Updated notification syntax to the modern notifies syntax
- Remove zlinux from the list of supported platforms
- Add platform support logic for Amazon Linux and Fedora
- Expand testing in the Kitchen configs to current platform releases
- Migrated to GitHub actions for testing

## v0.1.6

- Add packages for rhel family
- Fix typo in readme (thanks @jgoldschrafe)
- Move recipe inclusion to action in provider and use run_context instead of node directly (thanks @jgoldschrafe)

## v0.1.4

- Update service resource usage

## v0.1.2

- Use ephemeral store to build configuration
- Remove default uid and gid values for cgconfig groups

## v0.0.1

- Initial release
