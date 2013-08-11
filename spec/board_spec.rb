require 'spec_helper'
require 'active_support/core_ext/string'

describe ByzantionChess::Board do

  context 'board setup' do
    it 'should create same boards with initial position' do
      board1 = ByzantionChess::Board.new
      board2 = ByzantionChess::Board.new
      board1.should_not === board2
    end

    it 'should create board with additional info' do
      board = ByzantionChess::Board.new
      board.white_castle_possible.should be_true
    end

    it 'should create a new board with initial position' do
      board = ByzantionChess::Board.new
      board.pieces.size.should eql 32
      board.to_move.should eql ByzantionChess::WHITE
      king = board.select_piece(ByzantionChess::King, ByzantionChess::WHITE).first
      king.should_not be_nil
      king.field.to_s.should eql "e1"

      queen = board.select_piece(ByzantionChess::Queen, ByzantionChess::WHITE).first
      queen.should_not be_nil
      queen.field.to_s.should eql "d1"

      rooks = board.select_piece(ByzantionChess::Rook, ByzantionChess::WHITE)
      rooks.should_not be_nil
      rooks.should be_kind_of Array
      rooks.size.should eql 2

      bishops = board.select_piece(ByzantionChess::Bishop, ByzantionChess::WHITE)
      bishops.should_not be_nil
      bishops.should be_kind_of Array
      bishops.size.should eql 2

      knights = board.select_piece(ByzantionChess::Knight, ByzantionChess::WHITE)
      knights.should_not be_nil
      knights.should be_kind_of Array
      knights.size.should eql 2

      pawns = board.select_piece(ByzantionChess::Pawn, ByzantionChess::WHITE)
      pawns.should_not be_nil
      pawns.should be_kind_of Array
      pawns.size.should eql 8
    end
  end

  context 'invalid moves' do
    it 'should not be able to make invalid moves' do
      board = ByzantionChess::Board.new
      move = ByzantionChess::Move.new("e2","e5", ByzantionChess::WHITE, 1)
      expect{move.execute(board)}.to raise_error(ByzantionChess::InvalidMoveException)
      move = ByzantionChess::Move.new("f1","d3", ByzantionChess::WHITE, 1)
      expect{move.execute(board)}.to raise_error(ByzantionChess::InvalidMoveException)
      move = ByzantionChess::Move.new("h1","h2", ByzantionChess::WHITE, 1)
      expect{move.execute(board)}.to raise_error(ByzantionChess::InvalidMoveException)
      move = ByzantionChess::Move.new("e1","d1", ByzantionChess::WHITE, 1)
      expect{move.execute(board)}.to raise_error(ByzantionChess::InvalidMoveException)
      move = ByzantionChess::Move.new("e1","g1", ByzantionChess::WHITE, 1)
      expect{move.execute(board)}.to raise_error(ByzantionChess::InvalidMoveException)
      move = ByzantionChess::Move.new("e2","e1", ByzantionChess::WHITE, 1)
      expect{move.execute(board)}.to raise_error(ByzantionChess::InvalidMoveException)
      move = ByzantionChess::Move.new("g1","g3", ByzantionChess::WHITE, 1)
      expect{move.execute(board)}.to raise_error(ByzantionChess::InvalidMoveException)
      move = ByzantionChess::Move.new("e1","e1", ByzantionChess::WHITE, 1)
      expect{move.execute(board)}.to raise_error(ByzantionChess::InvalidMoveException)
    end
  end

  context 'valid moves'  do

    it 'should be able to make moves' do
      board = ByzantionChess::Board.new
      move1 = ByzantionChess::Move.new("e2","e4", ByzantionChess::WHITE, 1)
      board.piece_from('e2').should be_a_kind_of ByzantionChess::Pawn
      expect{move1.execute(board)}.not_to raise_error
      board.piece_from('e2').should be_false
      board.piece_from('e4').should be_a_kind_of ByzantionChess::Pawn

      move2 = ByzantionChess::Move.new("d7","d5", ByzantionChess::BLACK, 1)
      board.piece_from("d7").should be_a_kind_of ByzantionChess::Pawn
      expect{move2.execute(board)}.not_to raise_error
      board.piece_from("d7").should be_false
      board.piece_from("d5").should be_a_kind_of ByzantionChess::Pawn

      move3 = ByzantionChess::Move.new("e4", "d5", ByzantionChess::WHITE, 2)
      board.piece_from("e4").should be_a_kind_of ByzantionChess::Pawn
      board.piece_from("d5").should be_a_kind_of ByzantionChess::Pawn
      board.piece_from("d5").color.should eql ByzantionChess::BLACK
      expect{move3.execute(board)}.not_to raise_error
      board.piece_from("e4").should be_false
      board.piece_from("d5").should be_a_kind_of ByzantionChess::Pawn
      board.piece_from("d5").color.should eql ByzantionChess::WHITE

      move4 = ByzantionChess::Move.new("g8", "f6", ByzantionChess::BLACK, 2)
      board.piece_from("f6").should be_false
      board.piece_from("g8").should be_a_kind_of ByzantionChess::Knight
      expect{move4.execute(board)}.not_to raise_error
      board.piece_from("g8").should be_false
      board.piece_from("f6").should be_a_kind_of ByzantionChess::Knight
      board.piece_from("f6").color.should eql ByzantionChess::BLACK

      move5 = ByzantionChess::Move.new("g1", "f3", ByzantionChess::WHITE, 3)
      board.piece_from("f3").should be_false
      board.piece_from("g1").should be_a_kind_of ByzantionChess::Knight
      expect{move5.execute(board)}.not_to raise_error
      board.piece_from("g1").should be_false
      board.piece_from("f3").should be_a_kind_of ByzantionChess::Knight
      board.piece_from("f3").color.should eql ByzantionChess::WHITE

      move6 = ByzantionChess::Move.new("g7","g6", ByzantionChess::BLACK, 3)
      board.piece_from("g7").should be_a_kind_of ByzantionChess::Pawn
      expect{move6.execute(board)}.not_to raise_error
      board.piece_from("g7").should be_false
      board.piece_from("g6").should be_a_kind_of ByzantionChess::Pawn

      move7 = ByzantionChess::Move.new("f1", "d3", ByzantionChess::WHITE, 4)
      board.piece_from("f1").should be_a_kind_of ByzantionChess::Bishop
      board.piece_from("d3").should be_false
      expect{move7.execute(board)}.not_to raise_error
      board.piece_from("f1").should be_false
      board.piece_from("d3").should be_a_kind_of ByzantionChess::Bishop
      board.piece_from("d3").color.should eql ByzantionChess::WHITE

      move8 = ByzantionChess::Move.new("b8", "d7", ByzantionChess::BLACK, 4)
      board.piece_from("d7").should be_false
      board.piece_from("b8").should be_a_kind_of ByzantionChess::Knight
      expect{move8.execute(board)}.not_to raise_error
      board.piece_from("b8").should be_false
      board.piece_from("d7").should be_a_kind_of ByzantionChess::Knight
      board.piece_from("d7").color.should eql ByzantionChess::BLACK

      move9 = ByzantionChess::Castle.new("e1", "g1", ByzantionChess::WHITE, 5)
      board.piece_from("g1").should be_false
      board.piece_from("f1").should be_false
      board.piece_from("e1").should be_a_kind_of ByzantionChess::King
      board.piece_from("h1").should be_a_kind_of ByzantionChess::Rook
      expect{move9.execute(board)}.not_to raise_error
      board.piece_from("e1").should be_false
      board.piece_from("h1").should be_false
      board.piece_from("g1").should be_a_kind_of ByzantionChess::King
      board.piece_from("f1").should be_a_kind_of ByzantionChess::Rook

      move10 = ByzantionChess::Move.new("c7", "c5", ByzantionChess::BLACK, 5)
      board.piece_from("c7").should be_a_kind_of ByzantionChess::Pawn
      board.piece_from("c5").should be_false
      expect{move10.execute(board)}.not_to raise_error
      board.piece_from("c5").should be_a_kind_of ByzantionChess::Pawn
      board.piece_from("c7").should be_false

      move11 = ByzantionChess::EnPassant.new("d5","c6", ByzantionChess::WHITE, 6)
      move11.should be_a_kind_of(ByzantionChess::EnPassant)
      board.piece_from("d5").should be_a_kind_of ByzantionChess::Pawn
      board.piece_from("c5").should be_a_kind_of ByzantionChess::Pawn
      board.piece_from("c6").should be_false
      expect{move11.execute(board)}.not_to raise_error
      board.piece_from("d5").should be_false
      board.piece_from("c5").should be_false
      board.piece_from("c6").should be_a_kind_of ByzantionChess::Pawn

      move12 = ByzantionChess::Move.new("f8","g7", ByzantionChess::BLACK, 6)
      board.piece_from("f8").should be_a_kind_of ByzantionChess::Bishop
      board.piece_from("g7").should be_false
      expect{move12.execute(board)}.not_to raise_error
      board.piece_from("f8").should be_false
      board.piece_from("g7").should be_a_kind_of ByzantionChess::Bishop
      board.piece_from("g7").color.should eql ByzantionChess::BLACK

      move13 = ByzantionChess::Move.new("c6","b7", ByzantionChess::WHITE, 7)
      board.piece_from("c6").should be_a_kind_of ByzantionChess::Pawn
      board.piece_from("b7").should be_a_kind_of ByzantionChess::Pawn
      board.piece_from("b7").color.should eql ByzantionChess::BLACK
      expect{move13.execute(board)}.not_to raise_error
      board.piece_from("c6").should be_false
      board.piece_from("b7").should be_a_kind_of ByzantionChess::Pawn
      board.piece_from("b7").color.should eql ByzantionChess::WHITE

      move14 = ByzantionChess::Castle.new("e8", "g8", ByzantionChess::BLACK, 7)
      board.piece_from("g8").should be_false
      board.piece_from("f8").should be_false
      board.piece_from("e8").should be_a_kind_of ByzantionChess::King
      board.piece_from("h8").should be_a_kind_of ByzantionChess::Rook
      expect{move14.execute(board)}.not_to raise_error
      board.piece_from("e8").should be_false
      board.piece_from("h8").should be_false
      board.piece_from("g8").should be_a_kind_of ByzantionChess::King
      board.piece_from("f8").should be_a_kind_of ByzantionChess::Rook

      move15 = ByzantionChess::Promotion.new(ByzantionChess::Queen, "b7", "a8", ByzantionChess::WHITE, 8)
      board.piece_from("b7").should be_a_kind_of ByzantionChess::Pawn
      board.piece_from("a8").should be_a_kind_of ByzantionChess::Rook
      expect{move15.execute(board)}.not_to raise_error
      board.piece_from("a8").should be_a_kind_of ByzantionChess::Queen
      board.piece_from("a8").color.should eql ByzantionChess::WHITE
      board.piece_from("b7").should be_false


=begin

      pawn9 = board.piece_from("b7")
      move15 = ByzantionChess::Move.new(pawn9, "a8", 8)
      move15.set_promoted_to(ByzantionChess::Queen)
      expect{board.make_move(move15)}.not_to raise_error
      board.piece_from("b7").should be_false
      board.piece_from("a8").should be_kind_of ByzantionChess::Queen
=end
    end

  end
end