require_relative '../xunit/xunit'
require_relative '../xunit/reporter'
require 'rspec'

class AllOkTest < XUnitTestCase
  def test_add
    assert_equals(4, 2+2)
  end

  def test_mult
    assert_equals(2, 2*1)
  end

end

class SomeFailTest < XUnitTestCase

  def test_equals
    assert_true(2==2)
  end

  def test_rompetodo
    assert_equals(1, 2)
  end

end


describe 'Testeando xunit' do

  it 'testear excepcion en assert true' do
    expect { XUnitTestCase.new.assert_false(false) }.to raise_error(AssertionError)
  end

  specify 'testear exception en assert false' do
    expect { XUnitTestCase.new.assert_true(false) }.to raise_error(AssertionError)
  end

  specify 'testear assert true ok' do
    expect(true).to eq(XUnitTestCase.new.assert_true(true))
  end

  specify 'testear assert equals ok' do
    expect(true).to eq(XUnitTestCase.new.assert_equals(1, 2-1))
  end

  it 'testear una clase si corre algo mal' do
    tester=XUnitFixture.new
    tester.run_tests(SomeFailTest)
    expect(1).to eq(tester.fixture_reporter.get_failures.length)
    expect(1).to eq(tester.fixture_reporter.get_success.length)
  end

  it 'testear que una clase corrio todo bien' do
    tester=XUnitFixture.new
    tester.run_tests(AllOkTest)
    expect(2).to eq(tester.fixture_reporter.get_success.length)
  end

  it 'testear que el fixture_reporter borre las estadisticas despes' do
    tester=XUnitFixture.new
    tester.add_class(SomeFailTest)
    tester.run_all_tests
    expect(0).to eq(tester.fixture_reporter.tests)
  end

end