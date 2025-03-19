def bubble_sort(input)
  input.size.downto(2).each do |window|
    input[0, window].each_with_index do |item, index|
      next unless index + 1 < input.size && item > input[index + 1]

      input[index], input[index + 1] = input[index + 1], input[index]
    end
  end
  input
end
