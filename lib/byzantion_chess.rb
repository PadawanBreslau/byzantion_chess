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
require 'byzantion_chess/chess_exceptions'

module ByzantionChess
    START_POSITION = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    WHITE = "white"
    BLACK = "black"
    A = 0
    B = 1
    C = 2
    D = 3
    E = 4
    F = 5
    G = 6
    H = 7
end
