import Foundation

enum TetrisPiece {
    
        case I
        case O
        case T
        case L
        case J
        case S
        case Z
        case Obs
        
        // Função que cria as matrizes de cada peça baseada nos casos do enum.
        var shape: [[Int]] {
            switch self {
            case .I:
                return [
                    [0, 0, 1, 0, 0],
                    [0, 0, 1, 0, 0],
                    [0, 0, 1, 0, 0],
                    [0, 0, 1, 0, 0]
                ]
                
            case .O:
                return [
                    [3, 3],
                    [3, 3]
                ]
                
            case .J:
                return [
                    [4, 0, 0],
                    [4, 4, 4],
                    [0, 0, 0]
                ]
                
            case .T:
                return [
                    [0, 5, 0],
                    [5, 5, 5],
                    [0, 0, 0]
                ]
                
            case .L:
                return [
                    [0, 0, 6],
                    [6, 6, 6],
                    [0, 0, 0]
                ]
                
            case .S:
                return [
                    [0, 7, 7],
                    [7, 7, 0],
                    [0, 0, 0]
                ]
                
            case .Z:
                return [
                    [8, 8, 0],
                    [0, 8, 8],
                    [0, 0, 0]
                ]
            case .Obs:
                return [
                    [9, 9],
                    [0, 0]
                ]
            }
        }
    }
