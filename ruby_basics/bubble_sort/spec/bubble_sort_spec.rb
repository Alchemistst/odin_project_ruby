require_relative '../bubble_sort'

RSpec.describe 'Bubble sort tests: ' do
  describe 'Should handle happy path =>' do
    it 'should sort [4,3,78,2,0,2]' do
      expect(bubble_sort([4, 3, 78, 2, 0, 2])).to eq([0, 2, 2, 3, 4, 78])
    end
    it 'should sort [4,3]' do
      expect(bubble_sort([4, 3])).to eq([3, 4])
    end
    it 'should sort [4]' do
      expect(bubble_sort([4])).to eq([4])
    end
    it 'should sort []' do
      expect(bubble_sort([])).to eq([])
    end
  end
end
