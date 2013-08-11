require 'byzantion_chess.rb'

class Game
    attr_accessor :header, :body, :moves

	def initialize(parsed_game)
    @header = parsed_game.elements.first.create_value_hash
    @body = parsed_game.elements.last
	  @moves = []
	end

	def convert_body_to_moves
	  last_move_number = 0
	  board = ByzantionChess::Board.new
	  @body.elements.each do |move|
	    next if !move.kind_of?(Sexp::PMove) && !move.kind_of?(Sexp::PCastle)
	    if move.kind_of?(Sexp::PCastle)
        move = create_castle(move, board, last_move_number)
      else
        move_text = move.text_value
        info = return_move_information(move_text)
        last_move_number = info[:move_number] if info[:move_number]
        pieces = board.get_possible_pieces(info[:piece_type], info[:piece_color], info[:field], info[:additional_info])
        raise ByzantionChess::InvalidMoveException.new("Too many or too few pieces to make move: #{pieces.size}") unless pieces.size == 1
        move = ByzantionChess::Move.new(pieces.first, info[:field], last_move_number, info[:additional_info])
        move.set_promoted_to(info[:promoted_piece]) if info[:promoted_piece]
      end
	    board.make_move(move)
		  @moves << move
    end
    return true
	end

	private

  def create_castle(move, board, last_move_number)
    move_text = move.text_value
    info = return_move_information(move_text, true)
    info[:piece_type] = ByzantionChess::King
    king = board.king(info[:piece_color])

    if 2 == move_text.split('-').size
      info[:field] = ByzantionChess::WHITE == info[:piece_color] ? ByzantionChess::Field.to_field("g1") : ByzantionChess::Field.to_field("g8")
    else
      info[:field] = ByzantionChess::WHITE == info[:piece_color] ? ByzantionChess::Field.to_field("c1") : ByzantionChess::Field.to_field("c8")
    end
    move = ByzantionChess::Move.new(king, info[:field], last_move_number, info[:additional_info])
    move
  end

	def return_move_information(move_text, castle=false)
	  info = {}
    promotion = move_text.split("=")

    if promotion.size == 2
      move_text = promotion.first
      info[:promoted_piece] = get_piece_from_letter(promotion.last[0])
    end

	  move_split = move_text.split('.')
	  info[:piece_color] = move_split.size == 2 ? ByzantionChess::WHITE : ByzantionChess::BLACK
	  info[:move_number] = move_split.first.strip if move_split.size == 2
	  move_string = move_split.last.strip
	  
	  raise InvalidMoveException.new("Wrong move description") if move_string.size < 2
	  
	  info[:check] = move_string.include?('+')
	  info[:take] = move_string.include?('x') || move_string.include?(':')

    return info if castle

	  move_string = move_string.delete('+').delete('x').delete(':')

	  if(2 == move_string.size)
	  	info[:piece_type] = ByzantionChess::Pawn
	  	info[:field] = ByzantionChess::Field.to_field(move_string)
	  elsif(3 == move_string.size)
	  	if move_string[0].ord >= 'a'.ord && move_string[0].ord <= 'h'.ord  # "cxd4"
	  	  info[:additional_info] = move_string[0]
	  	  info[:piece_type] = ByzantionChess::Pawn
	  	else
	  	  info[:piece_type] = get_piece_from_letter(move_string[0])
	  	end
	  	info[:field] = ByzantionChess::Field.to_field(move_string[1..2])
	  elsif(4 == move_string.size)
	    info[:piece_type] = get_piece_from_letter(move_string[0])
	  	info[:field] = ByzantionChess::Field.to_field(move_string[2..3])
	  	info[:additional_info] = move_string[1]
	  end	
	  info
	end

	def get_piece_from_letter(letter)
	  {"K" => ByzantionChess::King, "Q" => ByzantionChess::Queen, "R" => ByzantionChess::Rook,
	   "B" => ByzantionChess::Bishop, "N" => ByzantionChess::Knight}[letter]
	end	
end