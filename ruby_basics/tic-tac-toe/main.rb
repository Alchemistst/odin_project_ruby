require_relative './lib/game'

puts 'Welcome to tic-tac-toe'
puts 'Play typing [row],[col] ex. 1,2'
game = Game.new

game.start
