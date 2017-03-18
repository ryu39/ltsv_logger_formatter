# frozen_string_literal: true
require 'logger'
require 'ltsv'
require 'ltsv_logger_formatter/version'

# A logger formatter for logging in ltsv format.
#
# This is a sub class of ::Logger::Formatter.
# So you can use ::Logger's formatter as follows.
#   logger = ::Logger.new(STDOUT)
#   logger.formatter = ::LtsvLoggerFormatter.new
#   logger.info(key: 'value') # => level:INFO time:2017-03-19T01:47:50.280705 key:value
class LtsvLoggerFormatter < ::Logger::Formatter
  attr_accessor :severity_key, :time_key, :progname_key

  # Initialize formatter.
  #
  # @param [String] datetime_format Optional, datetime format string. Default is '%Y-%m-%dT%H:%M:%S.%6N'.
  # @param [Symbol] severity_key Optional, key for severity. Default is :level.
  # @param [Symbol] time_key Optional, key for time. Default is :time.
  # @param [Symbol] progname_key Optional, key for progname. Default is :progname.
  # @param [Object] filter Optional, object which responds to #filter, e.g. ActionDispatch::Http::ParameterFilter.
  #   This object used to filter parameter in hash such as 'password'.
  def initialize(datetime_format: '%Y-%m-%dT%H:%M:%S.%6N',
                 severity_key: :level, time_key: :time, progname_key: :progname, filter: nil)
    super()
    self.datetime_format = datetime_format
    @severity_key = severity_key
    @time_key = time_key
    @progname_key = progname_key
    @filter = filter
  end

  # Return formatted string using arguments.
  #
  # This method is expected to call by ::Logger
  #
  # @param [String] severity
  # @param [Time] time
  # @param [String] progname
  # @param [Hash, Exception, Object] data Data for logging,
  #   If data is Exception, then #message, #class and #backtrace is logged,
  #   or else if data can be respond to #to_hash, then #to_hash result is logged,
  #   or else #to_s result is logged with :message key.
  #   Hash, String, Exception or Object respond_to :to_hash can be used.
  def call(severity, time, progname, data)
    log_data = { @severity_key => severity, @time_key => format_datetime(time) }
    if progname
      log_data[@progname_key] = progname
    end
    log_data.merge!(format_data(data))
    ::LTSV.dump(log_data) + "\n"
  end

  private

  def format_data(data)
    return { message: data.message, class: data.class, backtrace: Array(data.backtrace).join('\n') } if data.is_a? Exception
    return { message: data.to_s } unless data.respond_to?(:to_hash)

    @filter ? @filter.filter(data.to_hash) : data.to_hash
  end
end
