require_relative '../board'

RSpec.describe 'Board tests' do
  describe 'check the status of the board' do
    it 'should return x wins by rows' do
      board = Board.new([[1, 1, 1], [0, 0, 0], [0, 0, 0]])
      expect(board.check_board_status).to eq 1
    end
    it 'should return x wins by columns' do
      board = Board.new([[1, 0, 0], [1, 0, 0], [1, 0, 0]])
      expect(board.check_board_status).to eq 1
    end
    it 'should return x wins by diagonal' do
      board = Board.new([[1, 0, 0], [0, 1, 0], [0, 0, 1]])
      expect(board.check_board_status).to eq 1
    end
    it 'should return x wins by antidiagonal' do
      board = Board.new([[0, 0, 1], [0, 1, 0], [1, 0, 0]])
      expect(board.check_board_status).to eq 1
    end
    it 'should return o wins by rows' do
      board = Board.new([[-1, -1, -1], [0, 0, 0], [0, 0, 0]])
      expect(board.check_board_status).to eq(-1)
    end
    it 'should return o wins by columns' do
      board = Board.new([[-1, 0, 0], [-1, 0, 0], [-1, 0, 0]])
      expect(board.check_board_status).to eq(-1)
    end
    it 'should return o wins by diagonal' do
      board = Board.new([[-1, 0, 0], [0, -1, 0], [0, 0, -1]])
      expect(board.check_board_status).to eq(-1)
    end
    it 'should return o wins by antidiagonal' do
      board = Board.new([[0, 0, -1], [0, -1, 0], [-1, 0, 0]])
      expect(board.check_board_status).to eq(-1)
    end
    it 'should return game still going' do
      board = Board.new([[0, 0, 0], [0, -1, 0], [-1, 0, 0]])
      expect(board.check_board_status).to eq(nil)
    end
    it 'should return game still going when board is empty' do
      board = Board.new([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
      expect(board.check_board_status).to eq(nil)
    end
    it 'should return tie' do
      board = Board.new([[1, 1, -1], [-1, -1, 1], [1, 1, -1]])
      expect(board.check_board_status).to eq(0)
    end
  end
  describe 'test add moves to the board' do
    it 'should add x move' do
      board = Board.new([[0, 0, 0], [0, -1, 0], [-1, 0, 0]])
      expect(board.add_move([0, 0], 1)).to eq([0, 0])
      expect(board.rows).to eq([[1, 0, 0], [0, -1, 0], [-1, 0, 0]])
    end
    it 'should add o move' do
      board = Board.new([[0, 0, 0], [0, -1, 0], [-1, 0, 0]])
      expect(board.add_move([2, 2], -1)).to eq([2, 2])
      expect(board.rows).to eq([[0, 0, 0], [0, -1, 0], [-1, 0, -1]])
    end
    it 'should return nil for move out of bounds' do
      board = Board.new([[0, 0, 0], [0, -1, 0], [-1, 0, 0]])
      expect(board.add_move([1, 3], -1)).to eq(nil)
      expect(board.rows).to eq([[0, 0, 0], [0, -1, 0], [-1, 0, 0]])
    end
    it 'should return nil for move on a taken position' do
      board = Board.new([[0, 0, 0], [0, -1, 0], [-1, 0, 0]])
      expect(board.add_move([1, 1], -1)).to eq(nil)
      expect(board.rows).to eq([[0, 0, 0], [0, -1, 0], [-1, 0, 0]])
    end
  end
end
