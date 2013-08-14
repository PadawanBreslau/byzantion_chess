module Sexp

  class PAllGames < Treetop::Runtime::SyntaxNode

  end

  class PGame < Treetop::Runtime::SyntaxNode

  end

  class PHeaderBody < Treetop::Runtime::SyntaxNode

  end

  class PHeader < Treetop::Runtime::SyntaxNode
    def selfparse value
      val = value.split(" ",2)
      return [val[0].delete('['), val[1].delete('"]').rstrip]
    end

  end

  class PAllMoves < Treetop::Runtime::SyntaxNode
     
  end

  class PAllMovesWithResult < Treetop::Runtime::SyntaxNode
    
  end

  class POneMove < Treetop::Runtime::SyntaxNode

  end


  class PMove < Treetop::Runtime::SyntaxNode
    def self.save_move(move, body_id, depth=0)
      move = move.text_value.strip
      move_hash = {}

      if move.include? "."
        move_split = move.split(".")
        move_hash[:white] = (move_split.size <= 2)

        move_hash[:move_number] = move_split.first.to_i
        move_part = move_split.last

        #unless m.move_number == 1
          #prev_move = Move.find_all_by_body_id(body_id).last ## HERE
          #m.prev_move = prev_move.id
        #end

      else
        #prev_move = Move.find_all_by_body_id(body_id).last
        #m.prev_move = prev_move.id
        #m.move_number = prev_move.move_number
        #m.white = false
        move_part = move
      end

      if move_hash[:white] && move_part.include?("O-O-O")
        move_part.gsub! "O-O-O", "Kec1"
      end

      if move_hash[:white] && move_part.include?("O-O")
        move_part.gsub! "O-O", "Keg1"
      end

      if !move_hash[:white] && move_part.include?("O-O-O")
        move_part.gsub! "O-O-O", "Kec8"
      end

      if !move_hash[:white] && move_part.include?("O-O")
        move_part.gsub! "O-O", "Keg8"
      end

      move_hash[:is_check] = move_part.end_with?("+")
      move_part.delete! "+"

      last_char = move_part[-1]
      if last_char > "A" && last_char < "Z"
        move_hash[:is_promotion] = true
        move_part.chop!
        move_part.delete! "="
      end

      move_hash[:is_taking] = move_part.include?("x")
      move_part.delete! "x"
      move_part.strip!

      if move_part[0] > "A" && move_part[0] < "Z"
        move_hash[:piece] = move_part[0]
        move_part = move_part[1..-1]
      else
        move_hash[:piece] = "P"
      end

      move_hash[:start_field] = move_part[-3]
      move_hash[:finish_field] = move_part[-2..-1]

      return move_hash
    end

  end

  class PMoveNumber < Treetop::Runtime::SyntaxNode

  end


  class PComment < Treetop::Runtime::SyntaxNode
    def self.save_comment comment, body_id, last_move
      c = {}
      c[:body_id] = body_id
      c[:content] = comment.text_value
      c[:last_move_id] = last_move

      c
    end
  end

  class PVariation < Treetop::Runtime::SyntaxNode

  end

  class PResult < Treetop::Runtime::SyntaxNode
  end


  class PTakes < Treetop::Runtime::SyntaxNode
  end

  class PInteger < Treetop::Runtime::SyntaxNode

  end

  class PFloat < Treetop::Runtime::SyntaxNode

  end

  class PString < Treetop::Runtime::SyntaxNode

  end

  class PIdentifier < Treetop::Runtime::SyntaxNode

  end

  class PCastle < Treetop::Runtime::SyntaxNode

  end

end


class Treetop::Runtime::SyntaxNode
  def create_value_hash
    hash = {}
    self.elements.each do |element|
      hash[element.elements.first.text_value] = element.elements.last.text_value.gsub('"','')
# TODO - to hash values or recursive
    end
    hash  
  end  
end