require_relative './resultado'

class Reporter
  attr_accessor :results, :format_reporter, :color

  def initialize(format_reporter=StringFormatReporter)
    self.reset
    @format_reporter=format_reporter.new
  end

  def reset
    @results = []
    @color = :green
  end

  def success(test)
    @results << PassedResult.new(test)
  end

  def tests_ran
    @results.length
  end

  def failure(test, message)
    @format_reporter.report_failure(test, message)
    @results << FailedResult.new(test, message)
  end

  def error(test, exception)
    @format_reporter.report_error(test, exception)
    @results << ErrorResult.new(jtest)
  end

  def benchmark_and_fire_test(instance, method=nil)
    beginning_time = Time.now
    if block_given?
      yield
    else
      instance.send method
    end
    end_time = Time.now
    unless self.get_failures.length == 0 and self.get_errors.length == 0
      @color = :red
    end
    @format_reporter.report_results(beginning_time, end_time, self)
    self.reset
  end

  def filter_results(result_type)
    @results.select { |result| result.class.equal? result_type }
  end

  def get_errors
    self.filter_results ErrorResult
  end

  def get_success
    self.filter_results PassedResult
  end

  def get_failures
    self.filter_results FailedResult
  end

end

require 'colorize'

class StringFormatReporter

  def report_error(test, exception)
    puts exception.message.red
    puts exception.backtrace.join("\n").red
  end

  def report_failure(test, message)
    puts "Failure on test #{test}: #{message}".colorize(:light_yellow)
  end

  def report_results(beginning_time, end_time, reporter)
    puts "#{reporter.results.length} tests,#{reporter.get_success.length} tests ran ok, #{reporter.get_failures.length} failures,#{reporter.get_errors.length} errors.".
             colorize(reporter.color)
    puts "Finished tests in #{(end_time - beginning_time)*1000} milliseconds".colorize(:cyan)
  end

end
