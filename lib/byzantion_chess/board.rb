module ByzantionChess
  class Board
    attr_reader :pieces, :moves
    attr_accessor :to_move
    
    def initialize(fen = "", to_move = WHITE)
      @pieces = []
      fen.blank? ? readFEN(START_POSITION) : readFEN(fen)
      @to_move = to_move
      @moves = []
      raise "Unsuccessfull Board initialisation - invalid_position" unless self.valid_position?
    end

    def select_piece(klass,color)
      @pieces.select{|piece| piece.class == klass && piece.get_color == color}
    end
    
    def piece_from(field_string)
      field_taken(ByzantionChess::Field.to_field(field_string))
    end

    def valid_position?
      return false if select_piece(ByzantionChess::King, WHITE).size != 1 &&
      select_piece(ByzantionChess::King, BLACK) != 1
      @pieces.each_pair{|a,b| return false if a.same_location_as?(b)}
      #!self.is_check?
    end

    def add_piece(piece)
      return false unless piece
      if self.field_taken(piece.field)
        raise BoardSetupException "Duplicate pieces for a field"
      else
        @pieces << piece
      end
    end

    def field_taken(field)
      self.pieces.each do |p|
        return p if p.horizontal_line == field.horizontal_line && p.vertical_line == field.vertical_line
      end
      false
    end

    def readFEN fen
      # TODO Na razie sa tylko ruchy
      board, color_to_move, castles, en_passant, halfmove_clock, move_number = fen.strip.split(" ")     
      board.split("/").each_with_index do |line, index|
        column = 0
        line.each_char do |char|
          column +=1         
          field = ByzantionChess::Field.new(column-1, 7-index)         
          case char
            when '1','2','3','4','5','6','7','8'
              column += char.to_i-1
            when 'k'
              piece = ByzantionChess::King.new(field, BLACK)
            when 'q'
              piece = ByzantionChess::Queen.new(field, BLACK)
            when 'r'
              piece = ByzantionChess::Rook.new(field, BLACK)
            when 'b'
              piece = ByzantionChess::Bishop.new(field, BLACK)
            when 'n'
              piece = ByzantionChess::Knight.new(field, BLACK)
            when 'p'
              piece = ByzantionChess::Pawn.new(field, BLACK)
            when 'K'
              piece = ByzantionChess::King.new(field, WHITE)
            when 'Q'
              piece = ByzantionChess::Queen.new(field, WHITE)
            when 'R'
              piece = ByzantionChess::Rook.new(field, WHITE)
            when 'B'
              piece = ByzantionChess::Bishop.new(field, WHITE)
            when 'N'
              piece = ByzantionChess::Knight.new(field, WHITE)
            when 'P'
              piece = ByzantionChess::Pawn.new(field, WHITE)
          end
          self.add_piece(piece)
        end
      end
    end
  
    def writeFEN
      return "fen"
    end
    
    def get_possible_pieces(move)
      av_pieces = @pieces.select{|piece| piece.kind_of?(move.piece.class) && piece.color == move.piece.color}
      .select{|piece| piece.can_move_to_field?(move.finish) || (piece.can_take_on_field?(move.finish) && field_taken(move.finish))}
    end
  
    def make_move move
      raise WrongMoveException("Wrong move class") unless move.kind_of? ByzantionChess::Move
      destination = move.finish

      if move.piece.kind_of?(ByzantionChess::King) && (move.piece.vertical_line-destination.vertical_line).abs > 1
        ByzantionChess::Castle.new(self,move).castle
        return true
      end

      possible_pieces = get_possible_pieces(move).keep_if{|piece| path_is_not_obstructed?(piece, destination) }

      if move.piece.kind_of?(ByzantionChess::Pawn) && @moves.present? && 
        @moves.last.piece.kind_of?(ByzantionChess::Pawn) && @moves.last.en_passant

        en_pawns = ByzantionChess::EnPassant.new(self, move).get_pawns
        if en_pawns.present?
          possible_pieces.concat en_pawns
          @en_passant_possible = true
        end
      else
        @en_passant_possible = false
      end

      raise InvalidMoveException("No piece to make that move: #{move.inspect}") if possible_pieces.blank?
      
      if possible_pieces.size == 2
        if move.additional_info.ord >= 97
          possible_pieces.keep_if{|piece| piece.vertical_line == move.additional_info.ord - 97}
        else
          possible_pieces.keep_if{|piece| piece.horizontal_line == move.additional_info.ord-1}
        end
      end

      raise "No piece to make that move: #{move.inspect}" if possible_pieces.size != 1

      destroy_piece_on_field(destination)  #Destroy piece that is taken
      destroy_pawn_by_en_passant move  #Destroy pawn by en_passant
      piece = possible_pieces.first
      move.en_passant = true if move.piece.kind_of?(ByzantionChess::Pawn) && (piece.field.horizontal_line - destination.horizontal_line).abs == 2   #set if move is able to procees en_passant
      piece.update_position destination  #Update piece position
      if move.promotion_to  #Update piece if promotion
        new_piece = piece.promote(move.promotion_to)
        @pieces.delete(piece)
        @pieces << new_piece
      end
      piece.moved = true  #Set that this piece has moved
      @to_move = update_to_move
      raise "Invalid position" unless self.valid_position?
      @moves << move
      true
    end

    def king_checked?
      pieces = @pieces.select{|piece| piece.color != @to_move}
      king = select_piece(ByzantionChess::King, @to_move).first
      pieces.each do |piece|
        return true if piece.can_take_on_field?(king.field)
      end
      false
    end
    
    def path_is_not_obstructed?(piece, destination)
      return true if piece.class == ByzantionChess::Knight
      fields = Field.get_fields_between(piece.field, destination)
      
      fields.each do |field|
        return false if field_taken(field)
      end
      return true
    end
  
    def validate_game game_id
      @moves = Move.find_all_by_body_id(game_id)
      return false if @moves.empty?
      @moves.each do |move|
        return false unless self.make_move(move)
      end
      @pieces = generate_start_position
      true
    end

    def update_to_move
      if @to_move == WHITE
        return BLACK
      else
        return WHITE
      end
    end
  
    def destroy_piece_on_field field
      @pieces.delete_if{|piece| piece.vertical_line == field.vertical_line && piece.horizontal_line == field.horizontal_line}
    end

    def destroy_pawn_by_en_passant move
      return nil if !@en_passant_possible || piece_from(move.finish.to_s).present? || !move.finish.accessible_by_diagonal(move.piece.field)
      field = move.piece.color == ByzantionChess::WHITE ? Field.to_field(move.finish.neighbour_field(0, -1).to_s) : Field.to_field(move.finish.neighbour_field(0, 1).to_s)
      destroy_piece_on_field field
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

