# frozen_string_literal: true

class Square
  attr_accessor :position, :moves, :parent

  def initialize(position, moves = [], parent = nil)
    @position = position
    @moves = moves
    @parent = parent
  end

  def add_move(position)
    moves << position
  end

  def parent?
    parent ? true : false
  end

  def moves_as_coordinates
    moves.map(&:position)
  end

  def to_s
    "Position: #{position}, moves: #{moves_as_coordinates}#{parent? ? ", parent: #{parent}." : ''}"
  end
end

class ChessBoard
  attr_accessor :squares

  POSSIBLE_MOVES = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]].freeze

  def initialize
    @squares = make_board
    add_moves
  end

  def to_s
    s = ''
    squares.each do |_, value|
      s += "#{value}\n"
    end
    s
  end

  def print_self
    puts 'The chess board:'
    puts self
  end

  def knight_moves(start_coord, end_coord, queue = [])
    start_sqr = squares[start_coord]
    start_sqr.parent = -1
    end_point = knight_moves_rec(start_sqr, end_coord, queue)
    path = []
    until end_point == -1
      path << end_point
      end_point = end_point.parent
    end
    path = path.reverse
    puts "Knight got from #{start_coord} to #{end_coord} in #{path.length - 1} move(s). Here is the path:\n"
    path.each { |square| puts square.position.inspect }
    clear_history
    path
  end

  private

  def knight_moves_rec(cur_sqr, end_coord, queue = [])
    cur_sqr.moves.each do |move|
      unless move.parent?
        move.parent = cur_sqr
        queue << move
      end
    end
    cur_sqr = queue.shift
    return cur_sqr if cur_sqr.position == end_coord

    knight_moves_rec(cur_sqr, end_coord, queue)
  end

  def make_board
    board = {}
    [*0..7].each do |i|
      [*0..7].each do |j|
        board[[i, j]] = Square.new([i, j])
      end
    end
    board
  end

  def add_moves
    squares.each do |_, square|
      POSSIBLE_MOVES.each do |move|
        new_x = square.position[0] + move[0]
        new_y = square.position[1] + move[1]
        square.add_move(squares[[new_x, new_y]]) if new_x.between?(0, 7) && new_y.between?(0, 7)
      end
    end
  end

  def clear_history
    squares.each do |_, value|
      value.parent = nil
    end
  end
end

board = ChessBoard.new
board.print_self
board.knight_moves([0, 0], [2, 2])
