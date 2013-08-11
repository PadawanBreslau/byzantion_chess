module ByzantionChess
  class FenHelper

    def initialize(board)
      @board = board
    end

    def readFEN(fen)
      # TODO Na razie sa tylko figury
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
      #TODO
      return "fen"
    end



  end
end