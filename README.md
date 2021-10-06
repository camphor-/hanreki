# Hanreki

[![Gem Version](https://badge.fury.io/rb/hanreki.svg)](https://badge.fury.io/rb/hanreki)

Simple schedule manager for [CAMPHOR-](https://camph.net/)

## Features
- Manage public & private schedules
- Manage events using simple CSV master files
- Convert master files to iCal and JSON files

## Installation
### Gem
Install hanreki with gem command:

    $ gem install hanreki
    $ hanreki

### Bundler
You can also install hanreki with bundler. Add this line to your Gemfile:

```ruby
gem 'hanreki'
```

And then execute:

    $ bundle
    $ bundle exec hanreki

## Usage
Run `hanreki help` or `bundle exec hanreki help`.

### Create a master file
`hanreki blank` generates a master file for the next month.

### Sync
`hanreki sync` generates iCal and JSON files from master files.

### Edit
`hanreki edit` opens a editor and validates master files.
Hanreki chooses the editor in the following order:

1. Editor specified by the environment variable: `CAMPHOR_SCHEDULE_EDITOR`
2. Editor specified by the environment variable: `EDITOR`
3. `vi`

### Validation
`hanreki validate` validates master files.

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/camphor-/hanreki.

## Why "hanreki"?
This application is named after a Japanese word "[頒暦](https://ja.wikipedia.org/wiki/頒暦)".
