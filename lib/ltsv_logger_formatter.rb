require 'logger'
require 'ltsv'
require 'ltsv_logger_formatter/version'

class LtsvLoggerFormatter < ::Logger::Formatter
  attr_accessor :severity_key, :time_key, :progname_key

  # Initialize formatter.
  #
  # @param [String] datetime_format Optional, datetime format string. Default is '%Y-%m-%dT%H:%M:%S.%6N'.
  # @param [Symbol] severity_key Optional, key for severity. Default is :level.
  # @param [Symbol] time_key Optional, key for time. Default is :time.
  # @param [Symbol] progname_key Optional, key for progname. Default is :progname.
  def initialize(datetime_format: '%Y-%m-%dT%H:%M:%S.%6N',
                 severity_key: :level, time_key: :time, progname_key: :progname)
    super()
    self.datetime_format = datetime_format
    @severity_key = severity_key
    @time_key = time_key
    @progname_key = progname_key
  end

  # Return formatted string using arguments.
  #
  # This method is expected to call by ::Logger
  #
  # @param [String] severity
  # @param [Time] time
  # @param [String] progname
  # @param [Hash, String, Exception, Object] data Data for logging,
  #   Hash, String, Exception or Object respond_to :to_hash can be used.
  def call(severity, time, progname, data)
    log_data = { @severity_key => severity, @time_key => format_datetime(time) }
    if progname
      log_data.merge!( @progname_key => progname )
    end
    log_data.merge!(format_data(data))
    ::LTSV.dump(log_data) + "\n"
  end

  private

  def format_data(data)
    case data
    when Hash
      data
    when String
      { message: data }
    when Exception
      { message: data.message, class: data.class, backtrace: (data.backtrace || []).join("\\n") } # \n cannot be used in LTSV, so use \\n in backtrace.
    else
      data.to_hash
    end
  end
end
