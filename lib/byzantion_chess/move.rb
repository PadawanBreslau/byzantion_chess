module ByzantionChess
  class Move
    attr_reader  :finish, :start, :additional_info

    delegate :color, :to => :additional_info, :prefix => false
    delegate :number, :to => :additional_info, :prefix => false
    #delegate :promotion_to, :to => :additional_info, :prefix => false

    def initialize(start_field, finish_field, color, number=nil)
      @start = start_field.kind_of?(ByzantionChess::Field) ? start_field : Field.to_field(start_field)
      @finish = finish_field.kind_of?(ByzantionChess::Field) ? finish_field : Field.to_field(finish_field)
      @additional_info = AdditionalMoveInfo.new(color, number)
    end

    def execute(board)
      board.execute_move(self)
    end
  end 
end