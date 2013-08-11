require 'spec_helper'

describe ByzantionChess::Piece do
  it 'should create a new pieces' do
    expect{ ByzantionChess::King.new(ByzantionChess::Field.new(1,ByzantionChess::E), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ ByzantionChess::Queen.new(ByzantionChess::Field.new(1,ByzantionChess::D), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ ByzantionChess::Rook.new(ByzantionChess::Field.new(1,ByzantionChess::A), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ ByzantionChess::Bishop.new(ByzantionChess::Field.new(1,ByzantionChess::C), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ ByzantionChess::Knight.new(ByzantionChess::Field.new(1,ByzantionChess::B), ByzantionChess::WHITE)}.not_to raise_exception
    expect{ ByzantionChess::Pawn.new(ByzantionChess::Field.new(2,ByzantionChess::E), ByzantionChess::WHITE)}.not_to raise_exception
  end
end