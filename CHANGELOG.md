## [Unreleased]

## [0.1.0] - 2016-06-28

- Initial release

## [0.2.0] - 2016-10-10

- Show the current version with `hanreki version` or `hanreki --version`
- Add validation for "Open" events

## [0.2.1] - 2017-01-22

- Fix warning in Ruby 2.4

## [1.0.0] - 2017-03-21

### Breaking Changes

- All events are closed by default

### Internal

- Stop using CircleCI
- Update rake

## [1.1.0] - 2017-03-30

### Features

- Validate day of the week on loading files

### Internal

- Improve Ruby 2.1 support

## [1.2.0] - 2017-05-03

### Features

- Validate generated JSON files using JSON schema

### Internal

- Stop including unnecessary files to gem
- Update README.md

## [2.0.0] - 2017-08-21

### Breaking Changes

- Drop Ruby 2.1 support

### Features

- Validate number of columns
- Better validation error reporting

## [3.0.0] - 2017-09-21

### Breaking Changes

- Drop JSONP support

### Internal

- Update README.md

## [3.1.0] - 2017-10-30

### Enhancements

- Ensure events are sorted by dates

## [4.0.0] - 2020-04-12

### Breaking Changes

- Drop Ruby v2.2 and v2.3 support

### Enhancement

- Add validation for 'Online Open' event
