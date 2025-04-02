import Foundation

class Obstacle {
    var gravity: Int = 1
    var posL: Int
    var posC: Int
    var isDead : Bool = false
    var spd : Int = 1
    var gridMask: [[Int]] = Array(repeating: Array(repeating: 0, count: 20), count: 20)
    var pieceGrid : [[Int]] = TetrisPiece.Obs.shape
    var dir: Int
    
    init(posL: Int, posC: Int, dir: Int) {
        self.posL = posL
        self.posC = posC
        self.dir = dir
    }
    
    func newObstacle(posL: Int, posC: Int, spd: Int, dir: Int){
        self.posL = posL
        self.posC = posC
        self.spd = spd
        self.dir = dir
    }
    
    func moveObstacle(spd: Int) {
        self.spd = spd
        
        posC += spd * dir
    }
    
    func drawObstacle(grid: [[Int]]) -> [[Int]]{
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
    
    func isColliding(gridDead: [[Int]], collisionMask : [[Int]] ) -> Bool{
        let gridLocal: [[Int]] = gridDead
        let gridMaskLocal = collisionMask
        
        for (indexI, items) in gridLocal.enumerated() {
            for (indexJ, item) in items.enumerated() {
                    if (item * gridMaskLocal[indexI][indexJ] >= 1) {
                        return true
                    }
                }
            }
        return false
    }
    
    func drawMaskX() -> [[Int]]{
        var gridMaskLocal : [[Int]] = gridMask
        for (index_, items) in pieceGrid.enumerated() {
            for (index, item) in items.enumerated() {
                if( posC + index < 18 && posC + index - spd >= 0){
                    gridMaskLocal[posL+index_][posC+index+spd * dir] = item
                }
            }
        }
        return gridMaskLocal
    }
}


