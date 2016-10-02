require 'spec_helper'

describe LtsvLoggerFormatter do
  it 'has a version number' do
    expect(LtsvLoggerFormatter::VERSION).not_to be nil
  end

  describe '#call' do
    let(:time) { Time.new(2000, 1, 1, 12, 34, 56) }
    let(:progname) { nil }
    let(:data) do
      { key1: 'str', key2: 1, key3: true, key4: [1, 2], key5: { key: 'val' } }
    end

    let(:formatter) { LtsvLoggerFormatter.new }
    subject { formatter.call('INFO', time, progname, data) }

    it 'returns log message in ltsv format' do
      should eq "level:INFO\ttime:2000-01-01T12:34:56.000000\tkey1:str\tkey2:1\tkey3:true\tkey4:[1, 2]\tkey5:{:key=>\"val\"}"
    end

    context 'when datetime_format is specified' do
      let(:datetime_format) { '%Y-%m-%d %H:%M:%S' }
      let(:formatter) { LtsvLoggerFormatter.new(datetime_format: datetime_format) }

      it 'returns log message in ltsv format with specified datetime format' do
        should eq "level:INFO\ttime:2000-01-01 12:34:56\tkey1:str\tkey2:1\tkey3:true\tkey4:[1, 2]\tkey5:{:key=>\"val\"}"
      end
    end

    context 'when severity_key is specified' do
      let(:formatter) { LtsvLoggerFormatter.new(severity_key: :test) }

      it 'returns log message in ltsv format with specified severity key' do
        should eq "test:INFO\ttime:2000-01-01T12:34:56.000000\tkey1:str\tkey2:1\tkey3:true\tkey4:[1, 2]\tkey5:{:key=>\"val\"}"
      end
    end

    context 'when time_key is specified' do
      let(:formatter) { LtsvLoggerFormatter.new(time_key: :test) }

      it 'returns log message in ltsv format with specified time key' do
        should eq "level:INFO\ttest:2000-01-01T12:34:56.000000\tkey1:str\tkey2:1\tkey3:true\tkey4:[1, 2]\tkey5:{:key=>\"val\"}"
      end
    end

    context 'with progname' do
      let(:progname) { 'progname' }

      it 'returns log message in ltsv format with progname in ltsv format' do
        should eq "level:INFO\ttime:2000-01-01T12:34:56.000000\tprogname:progname\tkey1:str\tkey2:1\tkey3:true\tkey4:[1, 2]\tkey5:{:key=>\"val\"}"
      end

      context 'when progname_key is specified' do
        let(:formatter) { LtsvLoggerFormatter.new(progname_key: :test) }

        it 'returns log message in ltsv format with specified progname key' do
          should eq "level:INFO\ttime:2000-01-01T12:34:56.000000\ttest:progname\tkey1:str\tkey2:1\tkey3:true\tkey4:[1, 2]\tkey5:{:key=>\"val\"}"
        end
      end
    end

    context 'when data is String' do
      let(:data) { 'string' }

      it 'returns log message in ltsv format which contains String as message' do
        should eq "level:INFO\ttime:2000-01-01T12:34:56.000000\tmessage:string"
      end
    end

    context 'when data is Exception' do
      let(:data) do
        begin
          raise RuntimeError.new('error')
        rescue => e
          e
        end
      end

      it 'returns log message in ltsv format which contains message, class and backtrace' do
        should eq "level:INFO\ttime:2000-01-01T12:34:56.000000\tmessage:error\tclass:RuntimeError\tbacktrace:#{data.backtrace.join("\\n")}"
      end
    end

    context 'when data is Object witch can respond to #to_hash' do
      let(:data) { double('object') }
      before { expect(data).to receive(:to_hash).and_return({ key: 'val' }) }

      it 'returns log message in ltsv format which contains Object#to_hash result' do
        should eq "level:INFO\ttime:2000-01-01T12:34:56.000000\tkey:val"
      end
    end
  end
end
