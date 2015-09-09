require 'helper'

class EphemeralBufferTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def test_configure_without_log_level
    buf = Fluent::EphemeralBuffer.new

    buf.configure({})
    refute buf.instance_eval{ @log }.is_a?(Fluent::PluginLogger)
  end

  def test_configure_with_log_level
    buf = Fluent::EphemeralBuffer.new

    buf.configure({'log_level' => 'error'})
    assert buf.instance_eval{ @log }.is_a?(Fluent::PluginLogger)
    assert_equal Fluent::Log::LEVEL_ERROR, buf.instance_eval{ @log }.level
  end

  def test_configure_with_buffer_log_level
    buf = Fluent::EphemeralBuffer.new

    buf.configure({'buffer_log_level' => 'error'})
    assert buf.instance_eval{ @log }.is_a?(Fluent::PluginLogger)
    assert_equal Fluent::Log::LEVEL_ERROR, buf.instance_eval{ @log }.level
  end

  def test_configure_with_log_level_and_buffer_log_level
    buf = Fluent::EphemeralBuffer.new

    buf.configure({'log_leve' => 'error', 'buffer_log_level' => 'warn'})
    assert buf.instance_eval{ @log }.is_a?(Fluent::PluginLogger)
    assert_equal Fluent::Log::LEVEL_WARN, buf.instance_eval{ @log }.level
  end

  class DummyBufferedOutput < Fluent::BufferedOutput
    Fluent::Plugin.register_output('ephemeral_test', self)

    def write(chunk)
      raise "failed to write"
    end
  end

  CONFIG = %[
    buffer_type ephemeral
    disable_retry_limit true
  ]

  def create_driver(conf=CONFIG, tag='test')
    Fluent::Test::OutputTestDriver.new(DummyBufferedOutput, tag).configure(conf)
  end

  def test_emit
    d = create_driver
    d.instance.start

    d.emit({"a" => 1})

    d.instance.enqueue_buffer(true)
    d.instance.try_flush

    assert d.instance.instance_eval{ @buffer }.instance_eval{ @queue }.empty?
  end
end
