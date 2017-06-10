lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ltsv_logger_formatter/version'

Gem::Specification.new do |spec|
  spec.name          = 'ltsv_logger_formatter'
  spec.version       = LtsvLoggerFormatter::VERSION
  spec.authors       = ['ryu39']
  spec.email         = ['dev.ryu39@gmail.com']

  spec.summary       = 'A simple logger formatter for logging in ltsv format.'
  spec.description   = 'A simple logger formatter for logging in ltsv format.'
  spec.homepage      = 'https://github.com/ryu39/ltsv_logger_formatter'
  spec.license       = 'MIT'

  spec.files         = %w(LICENSE.txt) + Dir['lib/**/*.rb']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'ltsv'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'actionpack'
end
