class ByzantionChess::Piece
  attr_reader :field, :color, :board
  attr_accessor :moved
  
  delegate :horizontal_line, :to => :field, :prefix => false, :allow_nil => false
  delegate :vertical_line, :to => :field, :prefix => false, :allow_nil => false
  
  def initialize(field, color, board=nil, moved=false)
    raise ByzantionChess::InvalidPieceException unless field && color
    @field = field
    @color = color
    @moved = moved
    @board = board
  end
  
  def update_position field
    @field = field
  end

  def can_move_to_field? field
    false
  end

  def can_take_on_field?(field)
    can_move_to_field?(field)
  end

  def can_en_passant?(board, color, field)
    false
  end

  def can_be_promoted?
    false
  end

  def moved?
    @moved
  end

  def same_diagonal? field
    (@column.ord - field[0].ord).abs == (@line.ord - field[1].ord).abs
  end

  def get_color
    @color
  end
  
  def same_location_as?(piece)
    self.horizontal_line == piece.horizontal_line && self.vertical_line == piece.vertical_line
  end

  def promote klass
    klass.new(field, color, true, board)
  end

  private

  def good_field_format field
    field.size == 2 && field[0] >= "a" && field[0] <= "h" && field[1] >= "1" && field[1] <= "8"
  end
  
end