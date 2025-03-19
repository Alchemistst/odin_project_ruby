def count_down(number)
  if (number <= 0)
    puts number
  else
    puts number
    count_down(number - 1)
  end
end

puts "Count down from: "
count_down(gets.chomp.to_i)