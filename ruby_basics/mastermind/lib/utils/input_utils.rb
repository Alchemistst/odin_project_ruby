require_relative './constants'
module InputUtils
  def self.sanitized_user_input
    user_input = sanitize_input(gets)
    until valid_input?(user_input)
      puts 'Wrong input. Try again: '
      user_input = sanitize_input(gets)
    end
    user_input
  end

  def self.sanitize_input(input)
    input.chomp.strip.split('')
  end

  def self.valid_input?(input)
    input.size == Constants::DEFAULT_CODE_LENGTH && input.all? { |char| Constants::COLORS_MAP.keys.include?(char) }
  end
end
