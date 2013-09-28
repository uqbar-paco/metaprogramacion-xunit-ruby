require_relative '../xunit/xunit'
require_relative '../xunit/reporter'
require 'rspec'

class AllOkTest < XUnitTestCase
  def test_add
    assert_equals(4,2+2)
  end

  def test_mult
    assert_equals(2,2*1)
  end

end

class SomeFailTest < XUnitTestCase

  def test_equals
    assert_true(2==2)
  end

  def test_rompetodo
    assert_equals(1,2)
  end

end


describe 'Testeando xunit' do

  it 'testear excepcion en assert true' do
   expect {XUnitTestCase.new.assert_false(false)}.to raise_error(AssertionError)
  end

  specify 'testear exception en assert false' do
    expect {XUnitTestCase.new.assert_true(false)}.to raise_error(AssertionError)
  end

  specify 'testear assert true ok' do
    expect(true).to eq(XUnitTestCase.new.assert_true(true))
  end

  specify 'testear assert equals ok' do
    expect(true).to eq(XUnitTestCase.new.assert_equals(1,2-1))
  end

end