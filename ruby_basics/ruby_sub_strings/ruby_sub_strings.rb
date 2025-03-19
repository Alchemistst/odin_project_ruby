def substrings(test_string, dictionary)
  result = Hash.new(0)
  test_array = test_string.downcase.split
  dictionary.each_entry do |entry|
    test_array.each_entry do |test_entry|
      result[entry] = result[entry] + 1 if test_entry.include?(entry)
    end
  end
  result
end
