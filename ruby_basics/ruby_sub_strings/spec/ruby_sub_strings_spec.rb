require_relative '../ruby_sub_strings'

TEST_DICTIONARY = %w[below down go going horn how howdy it i low own part partner
                     sit]

RSpec.describe('Test ruby_sub_strings') do
  describe('Should handle easy path') do
    it('should get one word input: ex. "below"') do
      expect(substrings('below', TEST_DICTIONARY)).to eq({ 'below' => 1, 'low' => 1 })
    end

    it('should get multiple words input: ex. "Howdy partner, sit down! How\'s it going?"') do
      expect(substrings('Howdy partner, sit down! How\'s it going?',
                        TEST_DICTIONARY)).to eq({ 'down' => 1, 'go' => 1, 'going' => 1, 'how' => 2, 'howdy' => 1, 'it' => 2, 'i' => 3,
                                                  'own' => 1, 'part' => 1, 'partner' => 1, 'sit' => 1 })
    end
  end
end
