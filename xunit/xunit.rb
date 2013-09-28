require_relative '../xunit/reporter'

class RUnitFixture

  def initialize
    @klasses=Array.new
    @fixture_reporter = Reporter.new
  end

  def add_class klass
    @klasses << klass
  end

  def run_all_tests
    @fixture_reporter.benchmark_and_fire_test self,:_run_all_tests
  end

  def _run_all_tests
    @klasses.each do |klass|
      k=klass.new @fixture_reporter
      k.run_tests
    end
  end

end

class XUnitTestCase
  attr_accessor :reporter

  def initialize report=Reporter.new
    @reporter = report
  end

  def before
  end

  def after
  end

  def run test
    begin
      self.before()
      @reporter.test
      self.send test
      @reporter.success test
    rescue AssertionError => exception
      @reporter.failure test,exception.message
    rescue StandardError => exception
      puts exception.message
      puts exception.backtrace.join("\n")
      @reporter.error test
    rescue Exception => exception
      raise exception
    ensure
      self.after()
    end

  end

  def get_test_methods
    method_names = public_methods(true)
    method_names.select {|method_name| method_name ~/^test/}
  end

  def run_tests
    self.get_test_methods
    tests.each do |test|
      self.run test
    end
  end

  def assert_true value,message=nil
    unless value then
      raise AssertionError.new message
    end
    value
  end

  def assert_false value,message=nil
    self.assert_true message, !value
  end

  def assert_equals_with_message expected, result,message=nil
    self.assert_true expected == result,"#{message}. Expected #{expected} but was #{result}"
  end

  def assert_equals expected, result
    self.assert_equals_with_message expected, result
  end

  def assert_not_equals_with_message expected, result,message=nil
    self.assert_true expected != result,"#{message}. Expected #{expected} but was #{result}"
  end

  def assert_not_equals expected, result
    self.assert_not_equals_with_message expected, result
  end

  def assert_block
    message = 'Expected block to return true value'
    assert_true yield,message
  end

end

class AssertionError < StandardError; end