require_relative 'lib/game'
puts 'Welcome to MASTERMIND: Codemaker vs Codebreaker'
puts 'Choose your role: Codemaker (1), Codebreaker (2)'
game_mode = gets.chomp
until %w[1 2].include?(game_mode)
  puts 'Wrong input, try again... Possible values 1 or 2.'
  game_mode = gets.chomp
end
game = Game.new(game_mode)
game.start
