require_relative '../caesar'

RSpec.describe 'Caesar Cypher tests' do
  describe('Should transform') do
    it('Normal string') do
      expect(caesar('What a string!', 5)).to eq('Bmfy f xywnsl!')
    end

    it('All caps') do
      expect(caesar('WHAT A STRING!', 5)).to eq('BMFY F XYWNSL!')
    end

    it('All lower case') do
      expect(caesar('what a string!', 5)).to eq('bmfy f xywnsl!')
    end

    it('Edge case: Zz') do
      expect(caesar('Zz', 1)).to eq('Aa')
    end
  end
end
