require 'rspec'
require_relative '../xunit/xunit'

describe 'Cargar clases' do

  specify 'should cargar clase de archivo' do
    loader = XUnitFixture.new
    loader.load_classes './test/resource/*.rb'

  end
end