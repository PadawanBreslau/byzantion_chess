require 'spec_helper'
require 'active_support/core_ext/string'

describe ByzantionChess::Board do
  
  it 'should create same boards with initial position' do
    board1 = ByzantionChess::Board.new
    board2 = ByzantionChess::Board.new
    board1.should_not === board2
  end  
  
  it 'should create a new board with initial position' do
    board = ByzantionChess::Board.new
    board.pieces.size.should eql 32
    board.to_move.should eql "white"
    white_king = board.select_piece(ByzantionChess::King, "white")
    white_king.should_not be_nil
    #white_king.column.should eql "e"
    #white_king.column.should eql 1
    white_queen = board.select_piece(ByzantionChess::Queen, "white")
    white_queen.should_not be_nil
    
    white_rooks = board.select_piece(ByzantionChess::Rook, "white")
    white_rooks.should_not be_nil
    white_rooks.should be_kind_of Array
    white_rooks.size.should eql 2
    
    white_bishops = board.select_piece(ByzantionChess::Bishop, "white")
    white_bishops.should_not be_nil
    white_bishops.should be_kind_of Array
    white_bishops.size.should eql 2
    
    white_knights = board.select_piece(ByzantionChess::Knight, "white")
    white_knights.should_not be_nil
    white_knights.should be_kind_of Array
    white_knights.size.should eql 2
    
    white_pawns = board.select_piece(ByzantionChess::Pawn, "white")
    white_pawns.should_not be_nil
    white_pawns.should be_kind_of Array
    white_pawns.size.should eql 8
  end
  
  it 'should be able to make moves' do
    board = ByzantionChess::Board.new
    pawn = board.piece_from("e2")
    move1 = ByzantionChess::Move.new(pawn,"e4",1)
    expect{board.make_move(move1)}.not_to raise_error
    pawn.field.to_s.should eql "e4"
    
    pawn2 = board.piece_from("d7")
    move2 = ByzantionChess::Move.new(pawn2,"d5",1)
    expect{board.make_move(move2)}.not_to raise_error
    pawn2.field.to_s.should eql "d5"
    
    move3 = ByzantionChess::Move.new(pawn,"d5",2)
    expect{board.make_move(move3)}.not_to raise_error
    pawn.field.to_s.should eql "d5"
    
    knight2 = board.piece_from("g8")
    move4 = ByzantionChess::Move.new(knight2,"f6",2)
    expect{board.make_move(move4)}.not_to raise_error
    knight2.field.to_s.should eql "f6"
    
    knight1 = board.piece_from("g1")
    move5 = ByzantionChess::Move.new(knight1,"f3",3)
    expect{board.make_move(move5)}.not_to raise_error
    knight1.field.to_s.should eql "f3"
    
    pawn4 = board.piece_from("g7")
    move6 = ByzantionChess::Move.new(pawn4,"g6",3)
    expect{board.make_move(move6)}.not_to raise_error
    pawn4.field.to_s.should eql 'g6'
    
    bishop1 = board.piece_from("f1")
    move7 = ByzantionChess::Move.new(bishop1,"d3",4)
    expect{board.make_move(move7)}.not_to raise_error
    bishop1.field.to_s.should eql 'd3'
    
    knight4 = board.piece_from("b8")
    move8 = ByzantionChess::Move.new(knight4,"d7",4, 'b')
    expect{board.make_move(move8)}.not_to raise_error
    knight4.field.to_s.should eql "d7"
    
    castle = board.piece_from("e1")
    move9 = ByzantionChess::Move.new(castle,"g1",5)
    expect{board.make_move(move9)}.not_to raise_error
    board.piece_from("f1").should be_kind_of ByzantionChess::Rook
    
    pawn6 = board.piece_from("c7")
    move10 = ByzantionChess::Move.new(pawn6,"c5",5)
    expect{board.make_move(move10)}.not_to raise_error
    pawn6.field.to_s.should eql "c5"

    pawn7 = board.piece_from("d5")
    move11 = ByzantionChess::Move.new(pawn7, "c6", 6)
    expect{board.make_move(move11)}.not_to raise_error
    pawn7.field.to_s.should eql "c6"
    board.piece_from("c5").should be_false

    bishop2 = board.piece_from("f8")
    move12 = ByzantionChess::Move.new(bishop2,"g7",6)
    expect{board.make_move(move12)}.not_to raise_error
    bishop2.field.to_s.should eql 'g7'

    pawn8 = board.piece_from("c6")
    move13 = ByzantionChess::Move.new(pawn8, "b7", 7)
    expect{board.make_move(move13)}.not_to raise_error
    pawn8.field.to_s.should eql "b7"
    board.piece_from("c6").should be_false
    pawn8.should eql pawn

    castle2 = board.piece_from("e8")
    move14 = ByzantionChess::Move.new(castle2,"g8",7)
    expect{board.make_move(move14)}.not_to raise_error
    board.piece_from("f8").should be_kind_of ByzantionChess::Rook
    board.piece_from("g8").should be_kind_of ByzantionChess::King

    pawn9 = board.piece_from("b7")
    move15 = ByzantionChess::Move.new(pawn9, "a8", 8)
    move15.set_promoted_to(ByzantionChess::Queen)
    expect{board.make_move(move15)}.not_to raise_error
    board.piece_from("b7").should be_false
    board.piece_from("a8").should be_kind_of ByzantionChess::Queen
  end

  it 'should be able to make moves' do
    board = ByzantionChess::Board.new
    knight = board.piece_from("g1")
    move = ByzantionChess::Move.new(knight, "f3", 1)
    expect{board.make_move(move)}.not_to raise_error
    board.piece_from("f3").should be_kind_of ByzantionChess::Knight
    board.piece_from("g1").should be_false
  end

  it 'should be unable to make move when path is obstructed' do
    board = ByzantionChess::Board.new
    bishop = board.piece_from("f1")
    move = ByzantionChess::Move.new(bishop, "d3", 1)
    expect{board.make_move(move)}.to raise_error
    board.piece_from("f1").should be_kind_of ByzantionChess::Bishop
    board.piece_from("d3").should be_false
  end
end