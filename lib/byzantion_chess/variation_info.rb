module ByzantionChess
  class VariationInfo

    attr_accessor :move, :level, :previous_move

    def initialize(move, previous_move=nil)
      @move = move
      @level = 0
      @previous_move = previous_move
    end
  end
end