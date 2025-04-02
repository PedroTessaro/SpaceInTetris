import Foundation
import Darwin

class Game {
    //FPS
    var fps: Int
    var frameTime : UInt64
    var fpsCountGravity: Double = 0
    var fpsCountDrop: Int = 0
    
    //Grid
    var WIDTH : Int
    var HEIGHT : Int
    
    var gridA: [[Int]]
    
    var gridB: [[Int]]
    
    //Mascara Pecas mortas
    var gridDead: [[Int]]
    
    // Variáveis
    var code: AnsiCode = AnsiCode()
    var score: Int = 0
    var piece: Piece
    var pieceOld : Piece
    var obs: Obstacle? = Obstacle(posL: 9, posC: 3, dir: 1)
    var scale: Double = 1
    
    var vBorda = 2
    
    let pieces: String = "█"
    let blankSpace: String = "·"
    
    var changePiece = true
    
    let titulo : [String] = [
        "",
        "┌┐┌┐┌┐┌┐┌┐ ┬┌┐┌ ┌┬┐┌┐┌┬┐┬─┐┬┌┐",
        "└┐├┘├┤│ ├  ││││  │ ├  │ ├┬┘│└┐",
        "└┘┴ ┴┴└┘└┘ ┴┘└┘  ┴ └┘ ┴ ┴└─┴└┘"
    ]
    let scoreText : [String] = [
        "",
        "+--------------------------+",
        "| ┌┐┌┐┌┐┬─┐┌┐              |",
        "| └┐│ ││├┬┘├               |",
        "| └┘└┘└┘┴└─└┘              |",
        "+--------------------------+"
    ]
    let nextPieceGrid : [String] = [
        "",
        "+---------+",
        "|         |",
        "|         |",
        "|         |",
        "|         |",
        "+---------+"
    ]
        // Construtor Da Classe Game
    init(fps : Int, WIDTH : Int, HEIGHT : Int){
        self.fps = fps
        self.WIDTH = WIDTH
        self.HEIGHT = HEIGHT
        self.frameTime = 1_000_000_000 / UInt64(fps)
        self.gridA = Array(repeating: Array(repeating: 0, count: WIDTH), count: HEIGHT)
        self.gridB = Array(repeating: Array(repeating: -1, count: WIDTH), count: HEIGHT)
        self.gridDead = Array(repeating: Array(repeating: 0, count: WIDTH), count: HEIGHT)
        self.pieceOld = Piece(posL: 0, posC: 0, tPiece: randPiece())
        self.piece = Piece(posL: 1, posC: 10, tPiece: pieceOld.tPiece)
    }
    
    //funcoes
    func adicionarBordasEmMatriz(matriz: inout [[Int]]) {
        let linhas = matriz.count
        let colunas = matriz[0].count
        
        for i in 0..<colunas {
            matriz[0][i] = 2
            matriz[linhas - 1][i] = 2
        }
        
        for i in 0..<linhas {
            matriz[i][0] = 2
            matriz[i][colunas - 1] = 2
        }
    }
    
    func drawPieceInGame(posX : Int, posY : Int, cor : String , caracter : String){
        fputs("\u{1B}[\(posY);\(posX)f" + cor + caracter + "\u{001B}[0m", stdout)
        fflush(__stdoutp)
    }
    
    // Desenha a grid principal do jogo, checando qual é o tipo de peça para pintar das cores correspondentes
    func Draw_Grid(_ gridA: [[Int]], _ gridB: [[Int]]) {
        for i in 0..<WIDTH{
            for j in 0..<HEIGHT{
                if gridA[i][j] != gridB[i][j] {
                    if gridA[i][j] == 0 {
                        drawPieceInGame(posX: j+vBorda, posY: i+vBorda, cor: "", caracter: blankSpace)
                    }else if gridA[i][j] == 1{
                        drawPieceInGame(posX: j+vBorda, posY: i+vBorda, cor: "\u{001B}[38;5;196m", caracter: pieces)
                    }else if gridA[i][j] == 3{
                        drawPieceInGame(posX: j+vBorda, posY: i+vBorda, cor: "\u{001B}[32m", caracter: pieces)
                    }else if gridA[i][j] == 4{
                        drawPieceInGame(posX: j+vBorda, posY: i+vBorda, cor: "\u{001B}[38;5;226m", caracter: pieces)
                    }else if gridA[i][j] == 5{
                        drawPieceInGame(posX: j+vBorda, posY: i+vBorda, cor: "\u{001B}[34m", caracter: pieces)
                    }else if gridA[i][j] == 6{
                        drawPieceInGame(posX: j+vBorda, posY: i+vBorda, cor: "\u{001B}[35m", caracter: pieces)
                    }else if gridA[i][j] == 7{
                        drawPieceInGame(posX: j+vBorda, posY: i+vBorda, cor: "\u{001B}[36m", caracter: pieces)
                    }else if gridA[i][j] == 8{
                        drawPieceInGame(posX: j+vBorda, posY: i+vBorda, cor: "\u{001B}[38;5;130m", caracter: pieces)
                    }else if gridA[i][j] == 2{
                        drawPieceInGame(posX: j+vBorda, posY: i+vBorda, cor: "", caracter: pieces)
                    }else if gridA[i][j] == 9{
                        drawPieceInGame(posX: j+vBorda, posY: i+vBorda, cor: "", caracter: pieces)
                    }
                }
            }
        }
    }
    
    // Função para somar a pontuação do jogador
    func scorePoints(array: [Int]) {
        if (array.count == 1) {
            score+=10
        }else if(array.count == 2) {
            score+=30
        }else if(array.count == 3) {
            score+=50
        }else if(array.count == 4) {
            score += 80
        }
    }
    
    // Função que cria a interface principal do jogo
    func gameUI(){
        for i in 0..<4{
            drawPieceInGame(posX: 23, posY: 1+i, cor: "", caracter: titulo[i])
        }
        for i in 0..<6{
            drawPieceInGame(posX: 24, posY: 6+i, cor: "", caracter: scoreText[i])
        }
        for i in 0..<7{
            drawPieceInGame(posX: 32, posY: 12+i, cor: "", caracter: nextPieceGrid[i])
        }
        fputs("\u{1B}[\(9);\(46)f\(score)\u{001B}[0m", stdout)
        fflush(__stdoutp)
        
        drawPieceInGame(posX: 7, posY: 23, cor: "\u{001B}[90m", caracter: "'A' e'D' Movimenta p/ Esquerda e direita")
        drawPieceInGame(posX: 11, posY: 24, cor: "\u{001B}[90m", caracter: "Precione 'W' para rotacionar")
        drawPieceInGame(posX: 13, posY: 25, cor: "\u{001B}[90m", caracter: "Precione 'S' para cair")
        previewPiece()
    }
    
    // Função que mostra a próxima peça a ser colocada no jogo
    func previewPiece(){
        for (index_, itens) in pieceOld.pieceGrid.enumerated(){
            for (index, item) in itens.enumerated(){
                if item != 0{
                    drawPieceInGame(posX: 36+index, posY: 14+index_, cor: "", caracter: pieces)
                }
            }
        }
    }
    
    
    // Looping principal do jogo, onde rodamos toda a lógica, renderização, Buffer Swapping e Event Poolling necessário para que o jogo funcione
    
    func gameLoop(){
        terminalConfig()
        configureRawMode()
        setNonBlockMode()
        
        while (true) {
            // Logica
            let startTime = DispatchTime.now().uptimeNanoseconds

            adicionarBordasEmMatriz(matriz: &gridDead)
            fpsCountGravity += scale
            fpsCountDrop += 1
            
            
            let array: [Int] = piece.checkLines(gridDead: gridDead)
            
            if (!array.isEmpty){
                gridDead = piece.removeLines(indexList: array, gridDead: gridDead)
                scorePoints(array: array)
                if(score >= 10 && score < 20) {
                    scale = 1.2
                } else if(score >= 20 && score < 30) {
                    scale = 1.6
                } else if(score >= 40 && score < 50) {
                    scale = 2
                } else if(score >= 50) {
                    scale = 3
                }
            }
            
            if changePiece{
                pieceOld.newPiece(posL: 1, posC: 10, tPiece: randPiece())
                changePiece = false

            }
            if (fpsCountGravity >= Double(fps)/2) {
                // Lógica da peça
                if(!piece.isColliding(gridDead: gridDead,collisionMask: piece.drawMaskY())) {
                    piece.gravityPiece()
                    
                }else {
                    // Faz beep
                    print("\u{7}", terminator: "")
                    gridDead = piece.drawPiece(grid: gridDead)
                    piece.newPiece(posL: 1, posC: 10, tPiece: pieceOld.tPiece)
                    changePiece = true
                    if(piece.isColliding(gridDead: gridDead, collisionMask: piece.drawMaskGameOver())) {
                        print("\u{001B}[2J")
                        state = 3
                        break
                    }

                }
                
                if (piece.isCollidingObs(gridDead: gridDead, collisionMask: piece.drawMaskY())) {
                    obs = nil
                    obs = Obstacle(posL: 12, posC: 3, dir: 1)
                }
                
                // TODO
                // Lógica Obstáculo
                if let _obs = obs {
                    if(!_obs.isColliding(gridDead: gridDead, collisionMask: _obs.drawMaskX())) {
                        _obs.moveObstacle(spd: 2)
                    }else {
                        _obs.dir *= -1
                        
                    }
                    fpsCountGravity = 0
                    
                    obs = _obs
                }
            }
            
            //Rendering
            
            gridA = piece.drawPiece(grid: gridA)
            if let _obs = obs {
                gridA = _obs.drawObstacle(grid: gridA)
            }
            Draw_Grid(gridA, gridB)
            gameUI()
            
            // Buffer Swapping
            let aux = gridB
            gridB = gridA
            gridA = aux
            
            // Última parte do Buffer Swapping, onde zeramos a gridA nas primeiras iterações e atulizamos com as peças mortas nas subsequentes
            gridA = gridDead
            // Event Poolling
            var buffer = [UInt8](repeating: 0, count: 1)
            read(STDIN_FILENO, &buffer,1)
            let caractere = Character(UnicodeScalar(buffer[0]))
            
            
            if  caractere == "d" && !piece.isColliding(gridDead: gridDead, collisionMask: piece.drawMaskX(dir: 1)) {
                piece.movement(dir: 1)
            }else if caractere == "a" && !piece.isColliding(gridDead: gridDead, collisionMask: piece.drawMaskX(dir: -1)){
                piece.movement(dir: -1)
            }else if caractere == "w" && !piece.isColliding(gridDead: gridDead, collisionMask: piece.drawMaskW()){
                piece.pieceGrid = piece.rotatePiece(grid : piece.pieceGrid)
            }else if caractere == "s" && !piece.isColliding(gridDead: gridDead, collisionMask: piece.drawMaskY()) {
                if (fpsCountGravity < Double(fps)/2 && fpsCountDrop >= fps/4) {
                    piece.gravityPiece()
                }
            }
            
            // Término do frame, onde contamos o tempo entre as variáveis startTime e endTime para contabilizar o tamanho do frame
            let endTime = DispatchTime.now().uptimeNanoseconds
            let frameDuration = endTime - startTime
            if frameDuration < frameTime {
                let sleepTime = (frameTime - frameDuration) / 1_000_000
                usleep(UInt32(sleepTime * 1_000))
            }
        }
        
    }
}

