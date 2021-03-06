module ByzantionChess
  class AdditionalBoardInfo
    include ByzantionChess::ByzantionHelper

    attr_reader :white_castle_possible, :black_castle_possible, :en_passant, :is_check, :is_mate, :to_move
    attr_accessor :en_passant, :move_number, :moves_upto_draw

    def initialize(board)
      @white_castle_possible = {:long => true, :short => true}
      @black_castle_possible = {:long => true, :short => true}
      @en_passant = false
      @is_check = false
      @is_mate = false
      @to_move = ByzantionChess::WHITE
      @move_number = 1
      @moves_upto_draw = 0
    end

    def to_s
      result = ""
      result << "Move #{@move_number}"
      result << add_possible_castles
      result << ", EN PASSANT possible" if @en_passant
      result << ", CHECK" if @is_check
      result << ", MATE" if @is_mate
    end

    def move_up
      @move_number = @move_number + 1
    end

    # According to rules - 50 moves with any taking and pawn move is a draw
    def half_move_up(taking, klass)
      if taking || klass == ByzantionChess::Pawn
        @moves_upto_draw = 0
      else
        @moves_upto_draw = @moves_upto_draw + 1
      end
    end

    def update_to_move
      @to_move = next_color(@to_move)
    end

    def not_to_move
      next_color(@to_move)
    end

  private
    def add_possible_castles
      result = ""
      result << "White long castle possible;" if @white_castle_possible[:long]
      result << "Black short castle possible;" if @white_castle_possible[:short]
      result << "White long castle possible;" if @white_castle_possible[:long]
      result << "Black short castle possible" if @white_castle_possible[:short]
      result
    end
  end
end
