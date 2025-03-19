class Board
  attr_reader :rows

  DEFAULT_SIZE = 3
  MOVE_MAPPING = {
    1 => 'x', # Move made by x
    0 => ' ', # No move, empty cell
    -1 => 'o' # Move made by o
  }
  EMPTY_ROWS = (0..DEFAULT_SIZE - 1).collect { Array.new(3, 0) }
  def initialize(rows = EMPTY_ROWS)
    @rows = rows
    @string_board = ''
  end

  def render
    self.string_board = ''
    string_board << '  '
    rows.size.times { |col| string_board << " #{col}  " }
    string_board << "\n"
    rows.each_with_index do |row, index|
      string_board << index.to_s << '  '
      render_per_column(' | ', '', row)
      string_board << "\n"
      string_board << '   '
      render_per_column('--+-', '-') unless index == rows.size - 1
      string_board << "\n"
    end
    puts string_board
  end

  def check_board_status
    result = [check_rows, check_cols, check_diagonals].find { |res| !res.nil? }
    return result if !result.nil? || !rows.flatten.all? { |i| i != 0 }

    0
  end

  def add_move(coords, player)
    if movement_possible?(coords)
      rows[coords[0]][coords[1]] = player
      return coords
    end
    nil
  end

  private

  attr_accessor :string_board

  def movement_possible?(coords)
    result = rows.dig(coords[0], coords[1])
    !result.nil? && result.zero?
  end

  def render_per_column(symbol, end_symbol, row = [])
    rows.size.times do |col_index|
      string_board << if col_index < rows.size - 1
                        add_info_row(symbol, row, col_index)
                      else
                        add_info_row(end_symbol, row, col_index)
                      end
    end
  end

  def add_info_row(symbol, row, col_index)
    row.empty? ? symbol : append_move_mapping(symbol, row, col_index)
  end

  def append_move_mapping(symbol, row, col_index)
    "#{MOVE_MAPPING[row[col_index]]}#{symbol}"
  end

  def check_rows
    rows.each do |row|
      result = row.sum
      return result / rows.size if winning_result?(result)
    end
    nil
  end

  def check_cols
    rows.size.times do |index|
      result = 0
      rows.each do |row|
        result += row[index]
      end
      return result / rows.size if winning_result?(result)
    end
    nil
  end

  def check_diagonals
    [check_main_diagonal, check_antidiagonal].find { |result| !result.nil? }
  end

  def check_main_diagonal
    result = 0
    rows.size.times do |index|
      result += rows.dig(index, index)
      return result / rows.size if winning_result?(result)
    end
    nil
  end

  def check_antidiagonal
    result = 0
    rows.size.times do |index|
      result += rows.dig(index, rows.size - 1 - index)
      return result / rows.size if winning_result?(result)
    end
    nil
  end

  def winning_result?(result)
    [rows.size, -rows.size].include?(result)
  end
end
