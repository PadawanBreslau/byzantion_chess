module ByzantionChess
  class Board

    attr_reader :pieces, :moves, :additional_info, :board_helper, :fen_helper, :castle_helper

    delegate :readFEN, :to => :fen_helper, :prefix => false
    delegate :writeFEN, :to => :fen_helper, :prefix => false

    delegate :white_castle_possible, :to => :additional_info, :prefix => false
    delegate :black_castle_possible, :to => :additional_info, :prefix => false
    delegate :en_passant, :to => :additional_info, :prefix => false
    delegate :is_check, :to => :additional_info, :prefix => false
    delegate :is_mate, :to => :additional_info, :prefix => false
    delegate :to_move, :to => :additional_info, :prefix => false

    delegate :select_piece, :to => :board_helper, :prefix => false
    delegate :piece_from, :to => :board_helper, :prefix => false
    delegate :field_taken, :to => :board_helper, :prefix => false
    delegate :king_checked?, :to => :board_helper, :prefix => false
    delegate :valid_position?, :to => :board_helper, :prefix => false
    delegate :add_piece, :to => :board_helper, :prefix => false
    delegate :get_possible_pieces, :to => :board_helper, :prefix => false
    delegate :get_possible_pieces_from_move, :to => :board_helper, :prefix => false
    delegate :path_is_not_obstructed?, :to => :board_helper, :prefix => false
    delegate :validate_move, :to => :board_helper, :prefix => false
    delegate :destroy_piece_on_field, :to => :board_helper, :prefix => false

    delegate :update_rook_position, :to => :castle_helper, :prefix => false
    delegate :castle_possible?, :to => :castle_helper, :prefix => false


    def initialize(fen = nil, to_move = WHITE)
      @additional_info = AdditionalBoardInfo.new(to_move)
      @board_helper = BoardHelper.new(self)
      @fen_helper = FenHelper.new(self)
      @castle_helper = CastleHelper.new(self)
      @pieces = []
      @moves = []
      fen.present? ? readFEN(fen) : readFEN(START_POSITION)
      raise 'Unsuccessful Board initialisation - invalid_position' unless self.valid_position?
    end

    def to_s
      writeFEN
    end

    def execute_move(move)
      raise WrongMoveException.new('Wrong move class') unless move.kind_of? ByzantionChess::Move

      piece = piece_from(move.start)
      destination = move.finish
      validate_move(move, piece, destination)

      destroy_piece_on_field(destination)
      piece.update_position(destination)
      piece.moved = true
      update_en_passant(move, piece)
      @moves << move
      true
    end

    def execute_castle(move)
      raise WrongMoveException.new('Not a Castle') unless move.kind_of? Castle

      type = (3 == move.finish.vertical_line) ? :long : :short
      piece = piece_from(move.start)
      raise ImpossibleCastleException.new("Castle is not possible in current situation: #{move}") unless castle_possible?(piece, type)

      destination = move.finish
      validate_move(move, piece, destination)
      piece.update_position(destination)
      piece.moved = true
      color = piece.color
      update_rook_position(color, type)
      color == WHITE ? @additional_info.white_castle_possible[type] = false : @additional_info.black_castle_possible[type] = false
      @moves << move
      true
    end

    def execute_en_passant(move)
      raise WrongMoveException.new('Not an en passant') unless move.kind_of? EnPassant
      piece = piece_from(move.start)
      destination = move.finish
      validate_move(move, piece, destination)
      color = move.additional_info.color
      taken_location = destination.to_s[0].concat(move.start.to_s[1])

      piece_to_be_taken = piece_from(taken_location)
      raise InvalidMoveException.new("Impossible en passant - nothing to be taken") unless piece_to_be_taken
      destroy_piece_on_field(piece_to_be_taken.field)
      piece.update_position(destination)
      piece.moved = true
      @moves << move

      true
    end

    def execute_promotion(move)
      raise WrongMoveException.new('Not a promotion') unless move.kind_of? Promotion
      piece = piece_from(move.start)
      destination = move.finish
      validate_move(move, piece, destination)
      destroy_piece_on_field(move.start)
      destroy_piece_on_field(destination)
      self. pieces << move.new_piece.new(destination, piece.color, self, true)
      @moves << move

      true
    end

    private

    def update_en_passant(move, piece)
      if piece.kind_of?(Pawn) && (move.start.horizontal_line-move.finish.horizontal_line).abs == 2
        @additional_info.en_passant = piece
      else
        @additional_info.en_passant  = false
      end
    end
  end
end

class Array
  def each_pair_index
    (0..(self.length-1)).each do |i|
      ((i+1)..(self.length-1 )).each do |j|
        yield i, j
      end
    end
  end

  def each_pair
    self.each_pair_index do |i, j|
      yield self[i], self[j]
    end
  end
end 

