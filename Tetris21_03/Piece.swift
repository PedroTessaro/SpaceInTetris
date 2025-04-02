import Foundation

class Piece {
    var gravity: Int = 1
    var posL: Int
    var posC: Int
    var isDead : Bool = false
    var tPiece: TetrisPiece
    var spd : Int = 1
    var gridMask: [[Int]] = Array(repeating: Array(repeating: 0, count: 20), count: 20)
    var pieceGrid : [[Int]]
    
    
    // Construtor da Peça
    init(posL: Int, posC: Int, tPiece: TetrisPiece) {
        self.posL = posL
        self.posC = posC
        self.tPiece = tPiece
        self.pieceGrid = tPiece.shape
        
    }
    
    // Cria uma peça nova, função que serve como construtor, utilizada para evitar problemas como o optional
    func newPiece(posL: Int, posC: Int, tPiece: TetrisPiece){
        self.posL = posL
        self.posC = posC
        self.tPiece = tPiece
        self.pieceGrid = tPiece.shape
    }
    
    // Funçao que desenha a peça
    func drawPiece(grid: [[Int]]) -> [[Int]]{
        var gridLocal : [[Int]] = grid
        for (index_, items) in pieceGrid.enumerated() {
            for (index, item) in items.enumerated() {
                if item >= 1 {
                    gridLocal[posL+index_][posC+index] = item
                }
                
            }
        }
        return gridLocal
    }
    
    // Função que roda as peças
    func rotatePiece(grid : [[Int]]) ->[[Int]] {
        let n = pieceGrid.count
        var rotatedPiece = Array(repeating: Array(repeating: 0, count: n), count: n)
        
        for i in 0..<n {
            for j in 0..<n {
                if( grid[i][j] >= 1){
                    rotatedPiece[j][n - 1 - i] = grid[i][j]
                }
                
            }
        }
        return rotatedPiece
    }
    
    // Função que aplica a gravidade de maneira
    func gravityPiece() {
        posL += gravity
    }
    
    func movement(dir: Int) {
        posC += spd * dir
    }
    
    func isColliding(gridDead: [[Int]], collisionMask : [[Int]] ) -> Bool{
        let gridLocal: [[Int]] = gridDead
        let gridMaskLocal = collisionMask
        
        for (indexI, items) in gridLocal.enumerated() {
            for (indexJ, item) in items.enumerated() {
                if(item == 9) {
                    return false
                } else if (item * gridMaskLocal[indexI][indexJ] >= 1) {
                    return true
                }
            }
        }
        return false
    }
    
    // Função de colisão 
    func isCollidingObs(gridDead: [[Int]], collisionMask : [[Int]] ) -> Bool{
        let gridLocal: [[Int]] = gridDead
        let gridMaskLocal = collisionMask
        
        for (_, items) in gridLocal.enumerated() {
            for (_, item) in items.enumerated() {
                if(item == 9) {
                    return true
                }
            }
        }
        return false
    }
    
    // Percorre as linhas da matriz para checar se a linha está completa
    func checkLines(gridDead: [[Int]]) -> [Int] {
        var resultLine = 1
        var indexList: [Int] = []

        for (index_, items) in gridDead.enumerated() {
            resultLine = 2
            for (_, item) in items.enumerated() {
                if(item != 2) {
                    resultLine *= item
                }
            }
            
            if(resultLine != 0 && resultLine != 2 ){
                indexList.append(index_)
            }
            //print(resultLine)
        }
        return indexList
    }

    // Remove as linhas que foram checadas pela função checkLines
    func removeLines(indexList: [Int], gridDead: [[Int]]) -> [[Int]]{
        var gridDeadLocal = gridDead
        
        if (!indexList.isEmpty) {
            for i in 0..<indexList.count {
                for j in gridDead[i] {
                    gridDeadLocal[i][j] = 0
                }
            }

            for i in indexList {
                for j in 0..<20 {
                    for l in 0...19{
                        if(i - l > 0 && i - l - 1 > 0) {
                            gridDeadLocal[i-l][j] = gridDeadLocal[i-l-1][j]
                        }
                    }
                }
            }
      }
        return gridDeadLocal
    }
    
    // Escreve a máscara de colisão vertical das peças
    func drawMaskY() -> [[Int]]{
        var gridMaskLocal : [[Int]] = gridMask
        for (index_, items) in pieceGrid.enumerated() {
            for (index, item) in items.enumerated() {
                if(posL + index_  < 19 && item != 0) {
                    gridMaskLocal[posL+index_+gravity][posC+index] = item
                }
            }
        }
        return gridMaskLocal
    }
    
    // Escreve a máscara de colisão horizontal das peças
    func drawMaskX(dir: Int) -> [[Int]]{
        var gridMaskLocal : [[Int]] = gridMask
        for (index_, items) in pieceGrid.enumerated() {
            for (index, item) in items.enumerated() {
                if( posC + index < 19 && posC + index - spd >= 0){
                    gridMaskLocal[posL+index_][posC+index+spd * dir] = item
                }
            }
        }
        return gridMaskLocal
    }
   
    // Escreve a máscara de colisão em relação ao giro das peças
    func drawMaskW() -> [[Int]]{
        var gridMaskLocal : [[Int]] = gridMask
        let pieceGridLocal = rotatePiece(grid: pieceGrid)
        for (index_, items) in pieceGridLocal.enumerated() {
            for (index, item) in items.enumerated() {
                if(posC + index <= 19 && posC + index >= 0) {
                    gridMaskLocal[posL+index_][posC+index] = item
                }
            }
        }
        return gridMaskLocal
    }
    
    // Escreva a máscara de colisão em relação ao ponto de criação da peça com as peças mortas
    func drawMaskGameOver() -> [[Int]] {
        var gridMaskLocal : [[Int]] = gridMask
        for (index_, items) in pieceGrid.enumerated() {
            for (index, item) in items.enumerated() {
                gridMaskLocal[posL+index_][posC+index] = item
            }
        }
        return gridMaskLocal
    }
}


