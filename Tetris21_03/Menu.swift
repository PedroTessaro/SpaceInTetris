import Foundation

class Menu {
    var menuWidth : Int
    var menuHeight : Int
    var screenWidth = 25
    var screenHeight = 25
    let menuX : Int
    let menuY : Int
    var fallingBlocks: [Block] = []
    var stackedBlocks: [[String?]]
    var fullColumns: Set<Int> = []
    var game: Game = Game(fps: 30, WIDTH: 20, HEIGHT: 20)
    let colors = [
        "\u{001B}[38;5;196m",
        "\u{001B}[32m",
        "\u{001B}[38;5;226m",
        "\u{001B}[34m",
        "\u{001B}[35m",
        "\u{001B}[36m",
        "\u{001B}[38;5;130m",
    ]
    
    init(menuWidth : Int, menuHeight : Int){
        self.menuWidth = menuWidth
        self.menuHeight = menuHeight
        self.menuX = (screenWidth - menuWidth) / 2
        self.menuY = screenHeight / 2 - menuHeight / 2
        self.stackedBlocks = Array( repeating: Array(repeating: nil, count: screenWidth), count: screenHeight)
    }
    
    func coloredBlock(_ colorCode: String) -> String {
        return "\(colorCode)█\u{001B}[0m"
    }
     
    struct Block {
        var x: Int
        var y: Int
        var color: String
    }
    
     
    // Gera um bloco aleatório
    func spawnBlock() {
        // Verifica se o número de colunas preenchidas já é maior ou igual à largura da tela. Se for, não cria um novo bloco e sai da função
        if fullColumns.count >= screenWidth {
            return
        }
     
        // Gera uma posição aleatória para o bloco no eixo X, dentro da largura da tela
        var randomX = Int.random(in: 0..<screenWidth)
       
        // Verifica se a posição aleatória gerada já está ocupada (se já existe um bloco na coluna). Se estiver ocupada, gera uma nova posição até encontrar uma coluna livre
        while fullColumns.first(where: { $0 == randomX }) != nil {
            randomX = Int.random(in: 0..<screenWidth)
        }
     
        // Gera um índice aleatório para escolher uma cor da lista de cores e seleciona com base no índice
        let randomColorIndex = Int.random(in: 0..<colors.count)
        let randomColor = colors[randomColorIndex]
       
        // Cria um novo bloco na posição (randomX, 0) com a cor aleatória e adiciona ao array de blocos que estão caindo
        fallingBlocks.append(Block(x: randomX, y: 0, color: randomColor))
    }
    
    //Atualiza e checa a colisão
    func updateBlocks() {
        var updatedBlocks: [Block] = []  // Armazena os blocos que continuarão caindo
     
        for block in fallingBlocks {  // Percorre cada bloco atualmente na tela
            let nextY = block.y + 1  // Calcula a próxima posição vertical do bloco
     
            // Verifica se o bloco atingiu o fundo da tela ou colidiu com outro bloco
            if nextY >= screenHeight || stackedBlocks[nextY][block.x] != nil {
                stackedBlocks[block.y][block.x] = block.color // Se atingiu o fundo ou colidiu, fixa esse bloco na pilha (stackedBlocks)
     
                // Se um bloco foi empilhado na linha zero, marca essa coluna como cheia
                if stackedBlocks[0][block.x] != nil {
                    fullColumns.insert(block.x)
                }
            } else {
                // Se não colidiu nem atingiu o fundo, o bloco continua caindo
                updatedBlocks.append(Block(x: block.x, y: nextY, color: block.color))
            }
        }
     
        // Atualiza os blocos que ainda estão em movimento
        fallingBlocks = updatedBlocks
    }
    

    func drawMenu() {
        moveCursor(toX: menuX + 1, y: menuY + 1)
        fputs("\u{001B}[1;33m SPACE IN TETRIS\u{001B}[0m", stdout)
        let menuOptions = [
            "",
            "1. Play Game",
            "2. Exit"
        ]
       
        for (index, option) in menuOptions.enumerated() {
            moveCursor(toX: menuX + 1, y: menuY + 2 + index)
            fputs("\u{001B}[1;33m \(option)\u{001B}[0m", stdout)
        }
        fflush(stdout)
    }
     
    func drawScreen() {
        drawMenu()
        
        for (y, row) in stackedBlocks.enumerated() {
            for (x, cell) in row.enumerated() {
                if !(x >= menuX && x < menuX + menuWidth && y >= menuY && y < menuY + menuHeight) {
                    moveCursor(toX: x + 1, y: y + 1)
                    print(cell != nil ? coloredBlock(cell!) : " ", terminator: "")
                }
            }
        }
        
        for block in fallingBlocks {
            if !(block.x >= menuX && block.x < menuX + menuWidth && block.y >= menuY
                 && block.y < menuY + menuHeight)
            {
                moveCursor(toX: block.x + 1, y: block.y + 1)
                print(coloredBlock(block.color), terminator: "")
            }
        }
        
        fflush(stdout)
    }
     
    // Verifica se a tela está toda desenhada
    func isScreenFull() -> Bool {
        return stackedBlocks.allSatisfy { row in row.allSatisfy { $0 != nil } }
    }
     
     
    func menuLoop() -> Bool {
        var stopAnimation = false
        
        while true {
            if Int.random(in: 0...3) == 0 {
                spawnBlock()
            }
            
            if !stopAnimation {
                updateBlocks()
            }
            
            drawScreen()
            
            
            if isScreenFull() {
                stopAnimation = true
            }
            
            usleep(100)
            
            if stopAnimation {
                return true
            }
        }
    }
        
}

