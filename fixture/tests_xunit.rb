require_relative '../xunit/xunit'

class MultiplicationSuccessTest < XUnitTestCase

  def test_mult
    assert_equals 2*1, 2
  end

end

class SubtractionFailureTest < XUnitTestCase

  def test_subtraction
    assert_equals 3-1, 4
  end

end

