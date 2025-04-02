import Foundation

var state = -1

var menu = Menu(menuWidth: 17, menuHeight: 6)
var game : Game? = Game(fps: 30, WIDTH: 20, HEIGHT: 20)

//GameOver
var gridText : [String] = [
    "+====================================+",
    "| ██████╗  █████╗ ███╗   ███╗███████╗|",
    "|██╔════╝ ██╔══██╗████╗ ████║██╔════╝|",
    "|██║  ███╗███████║██╔████╔██║█████╗  |",
    "|██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  |",
    "|╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗|",
    "| ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝|",
    "|                                    |",
    "| ██████╗ ██╗   ██╗███████╗██████╗   |",
    "|██╔═══██╗██║   ██║██╔════╝██╔══██╗  |",
    "|██║   ██║██║   ██║█████╗  ██████╔╝  |",
    "|██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗  |",
    "|╚██████╔╝ ╚████╔╝ ███████╗██║  ██║  |",
    "| ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝  |",
    "+====================================+"
]

// Função que randomiza as peças, excluindo o Obstáculo, que não é jogável
func randPiece() -> TetrisPiece{
    let rnum = Int.random(in: 0...6)
    switch rnum{
    case 0:
        return TetrisPiece.I
    case 1:
        return TetrisPiece.O
    case 2:
        return TetrisPiece.L
    case 3:
        return TetrisPiece.J
    case 4:
        return TetrisPiece.S
    case 5:
        return TetrisPiece.Z
    default:
        return TetrisPiece.T
    }
}

// Função que lida com a tela de Game Over
func over(posX: Int, posY: Int) {
    for _ in 0..<50 {
        print("\u{001B}[41m")
    }
    fputs("\u{001B}[0m", stdout)
    fflush(__stdoutp)
    
    for i in 0..<15{
        fputs("\u{1B}[\(posY+i);\(posX)f\u{001B}[41m\(gridText[i])", stdout)
        fflush(__stdoutp)
    }
    
    fputs("\u{1B}[\(18);\(18)f1- Tentar de Novo", stdout)
    fputs("\u{1B}[\(20);\(18)f2- Menu", stdout)
    fputs("\u{1B}[\(22);\(18)f3- Sair", stdout)
    fflush(__stdoutp)
    
    
    var closeLoop = false
    var input : String? = "0"
    while !closeLoop {
        moveCursor(toX: 18, y: 24)
        input = readLine()
        switch input {
        case "1":
            state = 2
            closeLoop = true
        case "2":
            state = 1
            closeLoop = true
        case "3":
            state = 0
            closeLoop = true
        default:
            fputs("\u{1B}[\(25);\(18)Posição Invalida", stdout)
            fflush(__stdoutp)
        }
        fflush(stdout)
    }
}

func printGameOver(posX: Int, posY: Int){
    for i in 0..<15{
        fputs("\u{1B}[\(posY+i);\(posX)f\u{001B}[41m\(gridText[i])", stdout)
        fflush(__stdoutp)
    }
}

func optionGameOver(){
    fputs("\u{1B}[\(18);\(18)f1- Tentar de Novo", stdout)
    fputs("\u{1B}[\(20);\(18)f2- Menu", stdout)
    fputs("\u{1B}[\(22);\(18)f3- Sair", stdout)
    fflush(__stdoutp)
}


func menuOptions(){
    menu.menuLoop()
    
    var closeLoop = false
    
    var input : String? = "0"
    while !closeLoop {
        moveCursor(toX: menu.menuX + 1, y: menu.menuY + 5)
        fputs("\u{001B}[1;33m Option: \u{001B}[0m", stdout)
        input = readLine()
        switch input {
        case "1":
            state = 2
            closeLoop = true
        case "2":
            state = 0
            closeLoop = true
        default:
            moveCursor(toX: menu.menuX + 1, y: menu.menuY + 6)
            print(" Opção inválida!")
            break
        }
        fflush(stdout)
    }
}

// Configura o Modo Raw, que faz com que os inputs do usuário possam ser feitos sem a confirmação e sem o retorno do output
func configureRawMode() {
    // Primeiro criamos uma variável que recebe a Struct termios() do Darwin, que controla coisas relacionadas ao terminal
    var terminalConfig = termios()
    // a função tcgetattr serve para ler
    tcgetattr(STDIN_FILENO, &terminalConfig)
    terminalConfig.c_lflag &= ~UInt(ICANON | ECHO)
    tcsetattr(STDIN_FILENO, TCSANOW, &terminalConfig)
}


func setNonBlockMode() {
    let flags = fcntl(STDIN_FILENO, F_GETFL)
    fcntl(STDIN_FILENO, F_SETFL, flags | O_NONBLOCK)
}

func NsetNonBlockMode() {
    let flags = fcntl(STDIN_FILENO, F_GETFL)
    fcntl(STDIN_FILENO, F_SETFL, ~(O_NONBLOCK))
}

// Função que volta o terminal para as configurações padrão
func restoreTerminal() {
    var terminalConfig = termios()
    tcgetattr(STDIN_FILENO, &terminalConfig)
    terminalConfig.c_lflag |= UInt(ICANON | ECHO)
    tcsetattr(STDIN_FILENO, TCSANOW, &terminalConfig)
}

// Função que limpa o terminal e deixa o cursor no topo da tela
func terminalConfig() {
    print("\u{001B}[H") // Move cursor para topo
    print("\u{001B}[?25l") // Esconde o cursor
    print("\u{001B}[2J") // Limpa a tela
    print("\u{001B}[0m")
}

//Coisas que vieram de Menu
func clearScreen() {
    print("\u{001B}[2J", terminator: "")
}
 
// Função que muda a posição do cursos para um x e y passados como parâmetro
func moveCursor(toX x: Int, y: Int) {
    // Movimenta o cursor para as coordenadas (x, y)
    print("\u{001B}[\(y);\(x)H", terminator: "")
}

terminalConfig()
state = 1


// Looping que lida com os estados do jogo, quando é 0, o looping termina, fazendo com que o jogo seja encerrado. Se o state == 1, o menu é chamado e se state == 2, o jogo é chamado.
while (state != 0) {
    switch state {
    case 1:
        terminalConfig()
        menuOptions()
    case 2:
        game = nil
        game = Game(fps: 30, WIDTH: 20, HEIGHT: 20)
        game!.gameLoop()
        
    case 3:
        terminalConfig()
        NsetNonBlockMode()
        restoreTerminal()
        over(posX: 7, posY: 2)
        for _ in 0..<50 {
            print("\u{001B}[40m")
        }
        
    default:
        terminalConfig()
        break
    }
}

terminalConfig()
