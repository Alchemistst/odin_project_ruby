require 'fileutils'
require 'date'
require 'msgpack'

HANGMAN = "
   ffff
  e   g
  d  hij
  c  k l
aabaa
"

SUBSMAP = {
  'a' => '_',
  'b' => '|',
  'c' => '|',
  'd' => '|',
  'e' => '|',
  'f' => '_',
  'g' => 'O',
  'h' => '/',
  'i' => '|',
  'j' => '\\',
  'k' => '/',
  'l' => '\\'
}

OUTPUT_DIR = '.saved'
OUTPUT_EXT = 'hngmn'
OUTPUT_FILE_PREFIX = 'hangman_'

def load_words(filepath)
  words = File.read(filepath)
  words.split("\n").filter { |word| word.size >= 5 && word.size <= 12 }
end

def render_hangman(attempt)
  result = HANGMAN.dup
  SUBSMAP.keys[0..attempt].each { |key| result.gsub!(key, SUBSMAP[key]) }
  SUBSMAP.keys[-SUBSMAP.size + attempt + 1..].each { |key| result.gsub!(key, ' ') }
  result
end

def sanitize_input(input)
  input.chomp.downcase
end

def check_input(range, allow_save)
  input = sanitize_input(gets)
  while input.size > 1 || !range.include?(input)
    break if input == 'save' && allow_save

    puts 'Wrong input try again: '
    input = sanitize_input(gets)
  end
  input
end

def replace_guesses(all_guesses, guess_word, user_guess)
  right_guess = guess_word.split('').each_with_index.filter do |char, _index|
    char == user_guess
  end
  right_guess.each { |char, index| all_guesses[index] = char }
  all_guesses
end

def format_file_name(timestamp)
  "#{OUTPUT_DIR}/#{OUTPUT_FILE_PREFIX}#{timestamp}.#{OUTPUT_EXT}"
end

def save_game(failed_attempts, guess_word, all_guesses, saved_game)
  timestamp = DateTime.now
  saved_file_name = format_file_name(timestamp)
  FileUtils.mkdir_p(OUTPUT_DIR)

  game_info = {
    id: timestamp.to_s,
    failed_attempts: failed_attempts,
    guess_word: guess_word,
    all_guesses: all_guesses
  }

  puts 'Do you want to overwrite? [y, n]' unless saved_game.nil?
  File.delete(format_file_name(saved_game['id'])) if !saved_game.nil? && check_input(%w[y n], false) == 'y'

  File.open(saved_file_name, 'w') { |file| file.write(game_info.to_msgpack) }

  puts 'Game saved!'
end

def game_summary(failed_attempts, guess_word, all_guesses)
  if failed_attempts == SUBSMAP.size - 1
    puts render_hangman(failed_attempts + 1)
    puts "Game over! The right word was: #{guess_word}"
  elsif guess_word == all_guesses.join
    puts 'You won!'
  end
end

def start_game(words, saved_game)
  failed_attempts = saved_game.nil? ? 0 : saved_game['failed_attempts']
  guess_word = saved_game.nil? ? words.sample : saved_game['guess_word']

  all_guesses = saved_game.nil? ? Array.new(guess_word.size, '_') : saved_game['all_guesses']

  while all_guesses.join != guess_word && failed_attempts < SUBSMAP.size - 1
    puts all_guesses.join(' ')
    puts render_hangman(failed_attempts)
    puts 'Input a letter: '
    user_guess = check_input(('a'..'z'), true)

    if user_guess == 'save'
      save_game(failed_attempts, guess_word, all_guesses, saved_game)
      break
    end

    if guess_word.include?(user_guess)
      puts guess_word
      puts 'Right guess!'
      all_guesses = replace_guesses(all_guesses, guess_word, user_guess)
    else
      failed_attempts += 1
      puts 'Wrong guess!'
    end

  end
  game_summary(failed_attempts, guess_word, all_guesses)
end

def load_game
  puts 'Type the number of the game that you want to load: '
  games_by_file = load_saved_files.map { |file| [file, load_from_saved_file(file)] }
  games_by_file.each_with_index do |file_game, index|
    file, game = file_game
    puts "#{index}. WORD: #{game['all_guesses'].join(' ')} DATE: #{parse_date_from_filename(file)}"
  end

  user_input = check_input(('0'..(games_by_file.size - 1).to_s), false)
  puts games_by_file[user_input.to_i]
  games_by_file[user_input.to_i][1]
end

def parse_date_from_filename(filename)
  DateTime.strptime(filename.split('.')[0].gsub(OUTPUT_FILE_PREFIX, ''), '%Y-%m-%dT%H:%M:%S%z')
end

def load_from_saved_file(filename)
  serialized = File.read("#{OUTPUT_DIR}/#{filename}")
  MessagePack.unpack(serialized)
end

def load_saved_files
  saved_files = []
  dir = Dir.new(OUTPUT_DIR)
  dir_file = dir.read
  until dir_file.nil?
    saved_files << dir_file if dir_file.split('.')[-1] == OUTPUT_EXT
    dir_file = dir.read
  end
  saved_files
end

def saved_files_exist?
  result = false
  dir = Dir.new(OUTPUT_DIR)
  dir_file = dir.read
  while !result && !dir_file.nil?
    result = dir_file.split('.')[-1] == OUTPUT_EXT
    dir_file = dir.read
  end
  dir.close
  result
end

def saved_directory_exist?
  File.directory?(OUTPUT_DIR)
end

puts 'WELLCOME TO HANGMAN'
puts 'Type 1 to play a new game'
puts 'Type 2 to load a saved game' if saved_directory_exist? && saved_files_exist?
user_input = check_input(('1'..'2'), false)

if user_input == '1'
  words = load_words('words.txt')
  start_game(words, nil)
else
  start_game(words, load_game)
end
