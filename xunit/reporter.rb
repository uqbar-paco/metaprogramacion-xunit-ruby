require_relative './resultado'

class Reporter
  attr_accessor :results

  def initialize
    self.reset
  end

  def reset
    @results = []
  end

  def success(test)
    @results << PassedResult.new(test)
  end

  def tests_ran
    @results.length
  end

  def failure(test, message)
    @results << FailedResult.new(test, message)
  end

  def error(test)
    @results << ErrorResult.new(test)
  end

  def benchmark_and_fire_test(instance, method=nil)
    beginning_time = Time.now
    if block_given?
      yield
    else
      instance.send method
    end
    end_time = Time.now
    puts "#{@results.length} tests,#{self.get_success.length} tests ran ok, #{self.get_failures.length} failures,#{self.get_errors.length} errors."
    puts "Finished tests in #{(end_time - beginning_time)*1000} milliseconds"
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
