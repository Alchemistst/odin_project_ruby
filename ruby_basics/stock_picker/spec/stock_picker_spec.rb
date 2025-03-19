require_relative '../stock_picker'

RSpec.describe('Stock picker tests') do
  describe 'Should pass happy paths' do
    it 'should return 1 as the buying day and 4 as selling day' do
      expect(stock_picker([17, 3, 6, 9, 15, 8, 6, 1, 10])).to eq([1, 4])
    end
    it 'should handle when lowest day is last' do
      expect(stock_picker([9, 9, 9, 9, 9, 9, 1])).to eq([0, 1])
    end
    it 'should handle when highest day is first' do
      expect(stock_picker([9, 1, 1, 1, 1, 1, 1])).to eq([1, 2])
    end
  end
end
