# Arfor

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/arfor`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arfor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arfor

## Usage

### Making puppet forge modules
```
arfor github_module
```

#### Features
* Metadata and github descriptions written
* PDQTest installed
* README.md re-written with link to reference docs
* Enable travis-ci testing


### Making control repositories
```
arfor control_repo
```

#### Control Repository features
* Fully documented
* Based on upstream puppetlabs example
* Built-in onceover support
* Built-in mock-Puppetfile for use by onceover during testing
* Hieradata validation
* Creates a local git repo with master branch replaced with production


### Agent installers
#### PE 2016.4.2 (LTS)
```
arfor agent_installers --pe-version 2016.4.2 --agent-version 1.7.1
```

#### PE 2016.5.1
```
arfor agent_installers --pe-version 2016.5.1 --agent-version 1.8.1
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/arfor.
