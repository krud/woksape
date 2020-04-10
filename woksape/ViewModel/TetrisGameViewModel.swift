//
//  TetrisGameViewModel.swift
//  woksape
//
//  Created by Kelly Rudnicki on 3/24/20.
//  Copyright © 2020 Kelly Rudnicki. All rights reserved.
//

import SwiftUI
import Combine

class TetrisGameViewModel: ObservableObject {
    @Published var tetrisGame = TetrisGameModel()
    
    var nRows: Int { tetrisGame.nRows }
    var nColumns: Int { tetrisGame.nColumns }
    
    var gameBoard: [[GameSquare]] {
        var board = tetrisGame.gameBoard.map {$0.map(convertSquare)}
        
        if let tetrimino = tetrisGame.tetrimino {
            for blockLocation in tetrimino.blocks {
                board[blockLocation.column + tetrimino.origin.column][blockLocation.row + tetrimino.origin.row] = GameSquare(color: findColor(blockType: tetrimino.blockType))
            }
        }
        return board
    }
    
    var anyCancellable: AnyCancellable?
    var lastMoveLocation: CGPoint?
    
    init() {
      anyCancellable = tetrisGame.objectWillChange.sink {
        self.objectWillChange.send()
      }
    }
    
    func convertSquare(block: GameBlock?) -> GameSquare {
        return GameSquare(color: findColor(blockType: block?.blockType))
    }
    
    
    func findColor(blockType: BlockType?) -> Color {
        switch blockType {
            case .i:
                return .whitesmoke
            case .j:
                return .whitesmoke
            case .l:
                return .whitesmoke
            case .o:
                return .whitesmoke
            case .s:
                return .whitesmoke
            case .t:
                return .whitesmoke
            case .z:
                return .whitesmoke
            case .none:
                return .cinder
        }
    }
}

struct GameSquare{
    var color: Color
}
