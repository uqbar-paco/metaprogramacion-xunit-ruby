module Abstract
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def abstract_methods(*args)
      args.each do |name|
        class_eval <<-EVAL
          def #{name}(*args)
            raise NotImplementedError.new('You must implement #{name}.')
          end
        EVAL
      end
    end
  end

end


class Result
  include Abstract

  attr_accessor :test
  abstract_methods :passed

  def initialize(test)
    @test = test
  end

end

class FailedResult < Result

  def initialize(test, message)
    @test = test
    @message = message
  end

  def passed
    false
  end

end

class PassedResult < Result

  def passed
    true
  end

end

class ErrorResult < Result

  def passed
    false
  end

end
