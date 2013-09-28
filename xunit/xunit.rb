require_relative '../xunit/reporter'

class XUnitFixture

  attr_accessor :klasses, :fixture_reporter

  def initialize
    @klasses=Array.new
    @fixture_reporter = Reporter.new
  end

  def add_class(klass)
    @klasses << klass
  end

  def run_all_tests
    @fixture_reporter.benchmark_and_fire_test self, :_run_all_tests
  end

  def _run_all_tests
    @klasses.each do |klass|
      self.run_tests klass
    end
  end

  def get_test_methods(klass)
    method_names = klass.public_instance_methods(true)
    method_names.select { |method_name| method_name.to_s.start_with?('test_') and klass.new.method(method_name) }
  end

  def run_tests(klass)
    self.get_test_methods(klass).each do |test|
      self.run klass.new, test
    end
  end

  def run(instance, test)
    begin
      instance.before()
      instance.send test
      @fixture_reporter.success test
    rescue AssertionError => exception
      @fixture_reporter.failure test, exception.message
    rescue StandardError => exception
      puts exception.message
      puts exception.backtrace.join("\n")
      @fixture_reporter.error test
    rescue Exception => exception
      #if any other exception apart from a normal exception occurs it should be re-raised
      raise exception
    ensure
      instance.after()
    end

  end

end

class XUnitTestCase

  def before
  end

  def after
  end

  def assert_true(value, message=nil)
    unless value then
      raise AssertionError.new message
    end
    value
  end

  def assert_false(value, message=nil)
    self.assert_true message, !value
  end

  def assert_equals_with_message(expected, result, message=nil)
    self.assert_true expected == result, "#{message}. Expected #{expected} but was #{result}"
  end

  def assert_equals(expected, result)
    self.assert_equals_with_message expected, result
  end

  def assert_not_equals_with_message(expected, result, message=nil)
    self.assert_true expected != result, "#{message}. Expected #{expected} but was #{result}"
  end

  def assert_not_equals(expected, result)
    self.assert_not_equals_with_message expected, result
  end

  def assert_block
    message = 'Expected block to return true value'
    assert_true yield, message
  end

end

class AssertionError < StandardError;
end