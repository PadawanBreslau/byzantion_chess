require 'active_support/core_ext/module/delegation'
require 'byzantion_chess/version'
require 'byzantion_chess/board'
require 'byzantion_chess/piece'
require 'byzantion_chess/king'
require 'byzantion_chess/queen'
require 'byzantion_chess/rook'
require 'byzantion_chess/bishop'
require 'byzantion_chess/knight'
require 'byzantion_chess/pawn'
require 'byzantion_chess/move'
require 'byzantion_chess/field'
require 'byzantion_chess/castle'
require 'byzantion_chess/en_passant'
require 'byzantion_chess/promotion'
require 'byzantion_chess/chess_exceptions'
require 'byzantion_chess/additional_move_info'
require 'byzantion_chess/additional_board_info'
require 'byzantion_chess/board_helper'
require 'byzantion_chess/fen_helper'
require 'byzantion_chess/castle_helper'
require 'pgn_parser/parser.rb'
require 'pgn_parser/game.rb'

module ByzantionChess
    START_POSITION = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    WHITE = "white"
    BLACK = "black"
    A = 1
    B = 2
    C = 3
    D = 4
    E = 5
    F = 6
    G = 7
    H = 8
end
