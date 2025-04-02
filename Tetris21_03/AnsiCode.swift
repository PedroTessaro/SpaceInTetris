import Foundation

enum ControleTerminal: String {
    //Cores
    case preto = "\u{001B}[30m"
    case vermelho = "\u{001B}[31m"
    case verde = "\u{001B}[32m"
    case amarelo = "\u{001B}[33m"
    case azul = "\u{001B}[34m"
    case magenta = "\u{001B}[35m"
    case ciano = "\u{001B}[36m"
    case branco = "\u{001B}[37m"
    case cinza = "\u{001B}[90m"
    
    //Resolucao
    case resolucao40x25 = "\u{001B}[=1h"
    case resolucao80x25 = "\u{001B}[=3h"
    case resolucao320x200_Colorido = "\u{001B}[=13h"
    case resolucao640x200_Colorido16 = "\u{001B}[=14h"
    case resolucao640x350_Monocromo = "\u{001B}[=15h"
    case resolucao640x350_Colorido16 = "\u{001B}[=16h"
    case resolucao640x480_Colorido16 = "\u{001B}[=18h"
    case resolucao320x200_Colorido256 = "\u{001B}[=19h"
    
    //Cursor
    case cursorInvisivel = "\u{001B}[?25l"
    case cursorVisivel = "\u{001B}[?25h"
    
    //Reset
    case resetTerminal = "\u{001B}[0m"
}

struct AnsiCode {
   func posicionarCursor(linha: Int, coluna: Int) -> String {
        return "\u{001B}[\(linha);\(coluna)H"
    }
    
    
    subscript(controle: ControleTerminal) -> String {
        return controle.rawValue
    }
}

