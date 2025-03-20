require_relative 'utils/input_utils'
require_relative 'utils/constants'

class Game
  def initialize(game_mode)
    @game_mode = game_mode
    @current_guess = 1
  end

  def start
    game_mode == '1' ? start_codemaker : start_codebreaker
  end

  private

  attr_accessor :current_guess, :code
  attr_reader :game_mode

  def start_codemaker
    render_colors_hint
    puts 'Create a code for the computer to guess: '
    self.code = InputUtils.sanitized_user_input
    result = codebreaker_game_loop(false)
    game_summary_codemaker(result)
  end

  def start_codebreaker
    self.code = generate_code
    result = codebreaker_game_loop(true)
    game_summary_codebreaker(result)
  end

  def codebreaker_game_loop(is_human)
    result = []
    until result.sum == Constants::MAX_SCORE || current_guess > Constants::MAX_NUMBER_OF_GUESSES
      render_colors_hint
      puts "(#{current_guess}/#{Constants::MAX_NUMBER_OF_GUESSES}) Guess the code: "
      guess_attempt = is_human ? InputUtils.sanitized_user_input : computer_input
      result = code_result(guess_attempt)
      self.current_guess += 1
      render(guess_attempt, result)
    end
    result
  end

  def game_summary_codebreaker(result)
    if result.sum == Constants::MAX_SCORE
      puts 'Hooray! you cracked the code!'
    else
      puts "The code wasn't cracked. The code was #{code}."
    end
  end

  def game_summary_codemaker(result)
    if result.sum != Constants::MAX_SCORE
      puts "Hooray! your code wasn't cracked!"
    else
      puts 'Your code was craked by the computer.'
    end
  end

  def render_colors_hint
    puts 'Colors: r b g y p o'
  end

  def render(guess_attempt, result)
    puts " |       | |#{result[0]} #{result[1]}| \n |#{guess_attempt.join(' ')}| |#{result[2]} #{result[3]}|"
  end

  def generate_code
    result = []
    Constants::DEFAULT_CODE_LENGTH.times.each { result.push(Constants::COLORS_MAP.keys.sample) }
    result
  end

  def code_result(guess_attempt)
    result = []
    guess_attempt.each_with_index do |guess, index|
      if code[index] == guess
        result.push(Constants::SCORE_MAP[:right_color_position])
      elsif code.include?(guess)
        result.push(Constants::SCORE_MAP[:right_color])
      else
        result.push(Constants::SCORE_MAP[:wrong])
      end
    end
    result.sort { |a, b| b <=> a }
  end

  def computer_input
    generate_code
  end
end
