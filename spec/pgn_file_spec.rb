require 'spec_helper'

describe PgnFile do

  context 'loading pgn file' do
    it 'should initialize pgn_file object' do
      expect{PgnFile.new('filepath.pgn')}.not_to raise_error
    end

    it 'should not be able to load a file that is not a pgn' do
      expect{PgnFile.new('filepath.png')}.to raise_error
    end

    it 'should not load a file when path is incorrect' do
      pgn_file = PgnFile.new('./spec/example_pgns/unexisting_filepath.pgn')
      expect{pgn_file.load_and_parse_games}.to raise_error(ByzantionChess::InvalidPGNFile)
    end

    it 'should return error if file is empty' do
      pgn_file = PgnFile.new('./spec/example_pgns/empty_file.pgn')
      expect{pgn_file.load_and_parse_games}.to raise_error(ByzantionChess::InvalidPGNFile)
    end
  end

  context 'parsing pgn file' do
    it 'should parse a one game valid file' do
      pgn_file = PgnFile.new('./spec/example_pgns/p.pgn')
      expect{pgn_file.load_and_parse_games}.not_to raise_error
      pgn_file.load_and_parse_games.should be_true
      pgn_file.games.should_not be_nil
      pgn_file.games.size.should eql 1
      game = pgn_file.games.first
      game.should be_kind_of(Game)
      game.header["White"].should eql 'Bitalzadeh Ali (NED)'
      game.header["Black"].should eql 'Zawadzka Jolanta (POL)'
      game.header["Result"].should eql '1-0'
      game.header["ECO"].should eql 'B80'
      game.header["Site"].should eql 'Deizisau (Germany)'
      game.header["Date"].should eql '2005.03.28'
      game.header["WhiteElo"].should eql "0"
      game.header["BlackElo"].should eql "2259"
      game.body.should_not be_nil
      game.body.should be_kind_of Sexp::PAllMovesWithResult
      @board = ByzantionChess::Board.new
      game.moves['0'].each do |move|
        board_before_move = @board.dup
        expect{move.execute(@board)}.not_to raise_error
        board_before_move.should_not eql @board
      end
      commented_moves = game.moves['0'].select{|m| m.comment.present?}
      commented_moves.should_not be_empty
      commented_moves.count.should eql 2
      commented_moves.first.comment.should eql 'Jestem wesoly Romek'
    end

    it 'should properly read variations' do
      pgn_file = PgnFile.new('./spec/example_pgns/v.pgn')
      expect{pgn_file.load_and_parse_games}.not_to raise_error
      game = pgn_file.games.first
      moves = game.moves['0']
      moves.count.should eql 4
      variation = game.moves['1']
      variation.count.should eql 3
      variation.last.previous_move.should eql variation[1]
      variation[1].previous_move.should eql variation[0]
      variation[0].previous_move.should eql moves[0]
      moves[3].previous_move.should eql moves[2]
      moves[2].previous_move.should eql moves[1]
      moves[1].previous_move.should eql moves[0]
      moves[0].previous_move.should be_nil

      game = pgn_file.games.last
      moves = game.moves['0']
      moves.count.should eql 4
      variation = game.moves['1']
      variation.count.should eql 7
      variation[2].previous_move.should eql variation[1]
      variation[1].previous_move.should eql variation[0]
      variation[0].previous_move.should eql moves[0]
      moves[3].previous_move.should eql moves[2]
      moves[2].previous_move.should eql moves[1]
      moves[1].previous_move.should eql moves[0]
      moves[0].previous_move.should be_nil
      subvariation = game.moves['2']
      subvariation.count.should eql 7
    end

    it 'should parse a one game valid file - 2' do
      pgn_file = PgnFile.new('./spec/example_pgns/beatka.pgn')
      expect{pgn_file.load_and_parse_games}.not_to raise_error
      pgn_file.load_and_parse_games.should be_true
      pgn_file.games.should_not be_nil
      pgn_file.games.size.should eql 1
      game = pgn_file.games.first
      game.should be_kind_of(Game)

      game.body.should_not be_nil
      game.body.should be_kind_of Sexp::PAllMovesWithResult
      @board = ByzantionChess::Board.new
      game.moves['0'].each do |move|
        board_before_move = @board.dup
        expect{move.execute(@board)}.not_to raise_error
        board_before_move.should_not eql @board
      end
      #TODO - check position
    end


    it 'should read moves of parsed game' do
      pgn_file = PgnFile.new('./spec/example_pgns/b1.pgn')
      expect{pgn_file.load_and_parse_games}.not_to raise_error
      pgn_file.load_and_parse_games.should be_true
      pgn_file.games.should_not be_nil
      pgn_file.games.size.should eql 90
      game = pgn_file.games.first
      game.should be_kind_of(Game)
      game.moves.should_not be_empty
      pgn_file.games.each do |game|
        board = ByzantionChess::Board.new
        board_before_move = board.dup
        game.moves['0'].each do |move|
          expect{move.execute(board)}.not_to raise_error
        end
        board.writeFEN
        board_before_move.should_not eql board
      end
    end


  end

  context 'big tounramnent files' do
    it 'should parse game from tashkient' do
      pgn_file = PgnFile.new('./spec/example_pgns/real_games/tash.pgn')
      expect{pgn_file.load_and_parse_games}.not_to raise_error
      games = pgn_file.games
      games.count.should eq 66
      games.each do |game|
        game.header.should_not be_empty
      end
    end

    it 'should parse game from candidates' do
      pgn_file = PgnFile.new('./spec/example_pgns/real_games/cand.pgn')
      expect{ pgn_file.load_and_parse_games}.not_to raise_error
      games = pgn_file.games
      games.count.should eq 56
      games.each do |game|
        game.header.should_not be_empty
      end
    end

    it 'should parse game from polish woman champ' do
      pgn_file = PgnFile.new('./spec/example_pgns/real_games/mpk.pgn')
      expect{pgn_file.load_and_parse_games}.not_to raise_error
      games = pgn_file.games
      games.count.should eq 45
      games.each do |game|
        game.header.should_not be_empty
      end
    end

    it 'should parse game from dortmund' do
      pgn_file = PgnFile.new('./spec/example_pgns/real_games/dort.pgn')
      expect{pgn_file.load_and_parse_games}.not_to raise_error
      games = pgn_file.games
      games.count.should eq 28
      games.each do |game|
        game.header.should_not be_empty
      end
    end
  end
end
