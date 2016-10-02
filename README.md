# LtsvLoggerFormatter

[![Build Status](https://travis-ci.org/ryu39/ltsv_logger_formatter.svg?branch=master)](https://travis-ci.org/ryu39/ltsv_logger_formatter)

A simple ruby logger formatter for logging in [LTSV](http://ltsv.org/) format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ltsv_logger_formatter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ltsv_logger_formatter

## Usage

Set your logger formatter and call with hash object.

```ruby
logger = Logger.new(STDOUT)
logger.formatter = LtsvLoggerFormatter.new

logger.info({ key: 'val' })
# => level:INFO      time:2016-10-03T00:27:11.734180 key:val
logger.info('progname') { { key: 'val' } }
# => level:INFO      time:2016-10-03T00:27:44.269682 progname:progname       key:val
```

You can pass String, Exception and Object that can respond to #to_hash.

```ruby
logger.info 'string'
# => level:INFO      time:2016-10-03T00:37:39.950529 message:string

begin
  raise RuntimeError.new('error')
rescue => e
  logger.error e
end
# => level:ERROR     time:2016-10-03T00:38:52.815406 message:error   class:RuntimeError      backtrace:(irb):16:in `irb_binding'\n...snip...`<main>'

object = Object.new
def object.to_hash
  { key: 'val' }
end
logger.info object
# => level:INFO      time:2016-10-03T00:43:52.458565 key:val
```

### Datetime Format ###

You can specify datetime format for time.

```ruby
logger.formatter = LtsvLoggerFormatter.new(datetime_format: '%Y%m%d %H%M%S')

logger.info({ key: 'val' })
# => level:INFO      time:20161003 003139    key:val=> true
```

### Key name ###

You can change the following key name.

* level
* time
* progname

```ruby
logger.formatter = LtsvLoggerFormatter.new(severity_key: :test1, time_key: :test2, progname_key: :test3)
logger.info('progname') { { key: 'val' } }
# => test1:INFO      test2:2016-10-03T00:45:52.073456        test3:progname  key:val
```

## Dependency

This gem uses [LTSV gem](https://github.com/condor/ltsv/blob/master/ltsv.gemspec).

## Development

After checking out the repo, run `bin/setup` to install dependencies. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 
To release a new version, update the version number in `ltsv_logger_formatter.rb`, 
and then run `bundle exec rake release`, which will create a git tag for the version, 
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ryu39/ltsv_logger_formatter.
This project is intended to be a safe, welcoming space for collaboration, 
and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

