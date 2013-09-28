#cambiar la clase Reporter para que tenga una coleccion de resultados y no varios arrays de tests
class Reporter
  attr_accessor :assertions,:errors,:failures,:tests

  def initialize
    self.reset
  end

  def reset
    self.assertions=[]
    self.failures = {}
    self.errors=[]
    self.tests=0
  end

  def success test
     self.assertions << test
  end

  def failure test,message
     self.failures[test] = message
  end

  def error test
    self.errors << test
  end

  def test
    self.tests+=1
  end

  def benchmark_and_fire_test instance, method=nil, *args
    beginning_time = Time.now
    if block_given?
      yield
    else
      instance.send method, args
    end
    end_time = Time.now
    puts "#{self.tests} tests, #{self.assertions.length} assertions, #{self.failures.length} failures,#{self.errors.length} errors."
    puts "Finished tests in #{(end_time - beginning_time)*1000} milliseconds"
    self.reset
  end

end