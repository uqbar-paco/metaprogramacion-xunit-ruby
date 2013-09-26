require 'test/unit'
require_relative '../xunit/xunit'
require_relative '../xunit/reporter'

class MyRUnitTest < XUnitTestCase

  def test_add
    assert_equals(4,2+2)
  end

  def test_mult
    assert_equals(2,2*1)
  end

  def test_equals
    assert_true(2==2)
  end

  def test_rompetodo
    assert_equals(1,2)
  end

  def test_generate_error
    raise StandardError 'Aca volo todo'
  end

end

class TestXUnit < Test::Unit::TestCase

  def setup
    @test_case=XUnitTestCase.new
    @reporter=Reporter.new
    @my_test_case=MyRUnitTest.new
  end

  #test assertions
  def test_fail_assert_true
    assert_raises(AssertionError){
      @test_case.assert_false(value=true)
    }
  end

  def test_fail_assert_false
    assert_raises(AssertionError){
      @test_case.assert_true(false)
    }
  end

  def test_success_assert_true
    assert_equal(true,@test_case.assert_true(true))
  end

  def test_success_assert_equals
    assert_equal(true,@test_case.assert_equals(1,2-1))
  end

  #tests unitarios de Runit
  def test_run_test
    assert_equal(true,@my_test_case.test_equals)
  end

  def test_assert_rompe_todo
    assert_raises(AssertionError){
      assert(@my_test_case.test_rompetodo)
    }
  end

  #test reporter
  def test_good_assertion
    @my_test_case.run(:test_add)
    self.assert_equal(1,@my_test_case.reporter.assertions.length)
  end

  def test_failure
    @my_test_case.run(:test_rompetodo)
    self.assert_equal(1,@my_test_case.reporter.failures.length)
  end

  def test_error
    @my_test_case.run(:test_generate_error)
    self.assert_equal(1,@my_test_case.reporter.errors.length)
  end



end