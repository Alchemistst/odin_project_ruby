def stock_picker(stock_data)
  best_result = []
  best_value = nil
  stock_data[0, stock_data.size - 1].each_with_index do |starting_value, index|
    (2..stock_data.size - index).each do |window_size|
      current_value = stock_data[index, window_size][-1] - starting_value
      if best_value.nil? || current_value > best_value
        best_result = [index, index + window_size - 1]
        best_value = current_value
      end
    end
  end
  best_result
end
