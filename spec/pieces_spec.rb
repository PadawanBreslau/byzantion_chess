require 'spec_helper'

describe ByzantionChess::Piece do
  it 'should create a new pieces' do
    expect{ king = ByzantionChess::King.new(ByzantionChess::Field.new(0,ByzantionChess::E), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ queen = ByzantionChess::Queen.new(ByzantionChess::Field.new(0,ByzantionChess::D), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ rook = ByzantionChess::Rook.new(ByzantionChess::Field.new(0,ByzantionChess::A), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ bishop = ByzantionChess::Bishop.new(ByzantionChess::Field.new(0,ByzantionChess::C), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ knight = ByzantionChess::Knight.new(ByzantionChess::Field.new(0,ByzantionChess::B), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ pawn = ByzantionChess::Pawn.new(ByzantionChess::Field.new(1,ByzantionChess::E), ByzantionChess::WHITE)}.not_to raise_exception
  end
end