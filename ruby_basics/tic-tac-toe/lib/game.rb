require_relative './board'
class Game
  PLAYER_MAPPING = {
    1 => 'x',
    -1 => 'o'
  }
  def initialize
    @current_player = 1
  end

  def start
    board = Board.new
    board_status = board.check_board_status
    while board_status.nil?
      board.render
      puts 'Wrong input, try again... ' while board.add_move(get_player_input, current_player).nil?
      change_player
      board_status = board.check_board_status
    end
    board.render
    if board_status != 0
      puts "Player #{PLAYER_MAPPING[board_status]} won!"
    else
      puts 'It was a tie!'
    end
  end

  private

  attr_accessor :current_player

  def get_player_input
    input = ''
    while input.empty?
      puts "Type your move player #{PLAYER_MAPPING[current_player]} => "
      input = gets.chomp.strip
      coords = input.split(',')
      unless coords.size > 2 || coords.size < 2 || coords.all? { |coord| !coord.match(/^\d+$/) }
        return coords.map(&:to_i)
      end

      puts 'Wrong input, try again...'
      input = ''
    end
  end

  def change_player
    self.current_player = current_player == 1 ? -1 : 1
  end
end
