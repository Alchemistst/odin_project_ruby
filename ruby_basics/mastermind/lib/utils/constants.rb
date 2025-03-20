module Constants
  attr_reader :color_map, :default_code_length, :max_number_of_guesses, :score_map, :max_score

  COLORS_MAP = {
    'b' => :blue,
    'g' => :green,
    'o' => :orange,
    'p' => :purple,
    'r' => :red,
    'y' => :yellow
  }
  DEFAULT_CODE_LENGTH = 4
  MAX_NUMBER_OF_GUESSES = 10
  SCORE_MAP = {
    right_color: 1,
    right_color_position: 2,
    wrong: 0
  }
  MAX_SCORE = DEFAULT_CODE_LENGTH * SCORE_MAP[:right_color_position]
end
