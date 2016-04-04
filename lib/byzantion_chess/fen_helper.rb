module ByzantionChess
  class FenHelper

    LETTER = {"ByzantionChess::King" => "k", "ByzantionChess::Queen" => "q","ByzantionChess::Rook" => "r",
       "ByzantionChess::Bishop" => "b","ByzantionChess::Knight" => "n","ByzantionChess::Pawn" => "p"}

    def initialize(board)
      @board = board
    end

    def readFEN(fen)
      board, color_to_move, castles, en_passant, halfmove_clock, move_number = fen.strip.split(" ")
      board.split("/").each_with_index do |line, index|
        column = 0
        line.each_char do |char|
          column +=1
          field = Field.new(column, 8-index)
          case char
            when '1','2','3','4','5','6','7','8'
              column += char.to_i-1
            when 'k'
              piece = King.new(field, BLACK, @board)
            when 'q'
              piece = Queen.new(field, BLACK, @board)
            when 'r'
              piece = Rook.new(field, BLACK, @board)
            when 'b'
              piece = Bishop.new(field, BLACK, @board)
            when 'n'
              piece = Knight.new(field, BLACK, @board)
            when 'p'
              piece = Pawn.new(field, BLACK, @board)
            when 'K'
              piece = King.new(field, WHITE, @board)
            when 'Q'
              piece = Queen.new(field, WHITE, @board)
            when 'R'
              piece = Rook.new(field, WHITE, @board)
            when 'B'
              piece = Bishop.new(field, WHITE, @board)
            when 'N'
              piece = Knight.new(field, WHITE, @board)
            when 'P'
              piece = Pawn.new(field, WHITE, @board)
          end
          @board.add_piece(piece)
        end
      end
    end

    def writeFEN
      result = ''
      8.downto(1) do |i|
        pieces = sort_pieces_by_verical_line(pieces_from_line(@board.pieces, i))
        one_line = create_fen_line(prepare_format(pieces))
        result << one_line
        result << '/' unless i == 1
      end
      result.concat(additional_info)
      result
    end

    private

    def prepare_format(pieces)
      pieces.map{|p| {:klass => p.class, :color => p.color, :line => p.vertical_line}}
    end

    def pieces_from_line(pieces, line)
      pieces.select{|piece| piece.field.horizontal_line == line}
    end

    def sort_pieces_by_verical_line(pieces)
      pieces.sort{|p1,p2| p1.field.vertical_line <=> p2.field.vertical_line}
    end

    def piece_to_literal(klass,color)
      letter = LETTER[klass]
      ByzantionChess::WHITE == color ? letter.upcase : letter
    end

    def create_fen_line(pieces)
      result = ''
      border = 1
      pieces.each do |piece|
        border_offset = piece[:line] - border
        result.concat(border_offset.to_s) if border_offset > 0
        result.concat(piece_to_literal(piece[:klass].to_s, piece[:color]))
        border = piece[:line] + 1
      end
      result.concat((9-border).to_s) if 9-border > 0
      result
    end

    def additional_info
      result = ' '
      color = @board.to_move == WHITE ? 'w' : 'b'
      result.concat(color).concat(castle_info)
      if @board.en_passant
        result.concat(@board.en_passant.field.to_s)
      else
        result.concat('-')
      end
      result.concat(" #{@board.moves_upto_draw} #{@board.move_number}")
      result
    end

    def castle_info
      result = ' '
      wc = @board.white_castle_possible
      bc = @board.black_castle_possible
      result.concat('K') if wc[:short]
      result.concat('Q') if wc[:long]
      result.concat('k') if bc[:short]
      result.concat('q') if bc[:long]
      result.concat('-')  if !wc[:long] && !wc[:short] && !bc[:long] && !bc[:short]
      result.concat(' ')
      result
    end

  end
end
