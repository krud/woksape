//
//  TetrisGameModel.swift
//  woksape
//
//  Created by Kelly Rudnicki on 3/24/20.
//  Copyright © 2020 Kelly Rudnicki. All rights reserved.
//

import SwiftUI

class TetrisGameModel: ObservableObject {
    var nRows: Int
    var nColumns: Int
        
    @Published var gameBoard: [[GameBlock?]]
    @Published var tetrimino: Tetrimino?
    
    var timer: Timer?
    var speed: Double
    
    init(nRows: Int = 23, nColumns: Int = 10) {
        self.nRows = nRows
        self.nColumns = nColumns
        
        gameBoard = Array(repeating: Array(repeating: nil, count: nRows), count: nColumns)
        speed = 0.5
        
        resumeGame()
    }
    
    func resumeGame(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true, block: runEngine)
        
    }
    
    func pauseGame(){
        timer?.invalidate()
    }
    
    func runEngine(timer:Timer){
        
        if clearLines() {
            print("line cleared")
            return
        }
        guard tetrimino != nil else {
            print("Spawning new tetrimino")
            tetrimino = Tetrimino.createNewTetrimino(nRows: nRows, nColumns: nColumns)
            if !isValidTetrimino(testTetrimino: tetrimino!){
                print("GameOver")
                pauseGame()
            }
            return
        }
        
        if moveTetriminoDown() {
            print("Moving tetrimino down")
            return
        }
        
        print("placing tetrimino")
        placeTetrimino()
        
    }
    
    func dropTetrimino() {
        while(moveTetriminoDown()) { }
    }
    
    func moveTetriminoDown() -> Bool {
        return moveTetrimino(rowOffset: -1, columnOffset: 0)
    }
    
    func moveTetriminoRight() -> Bool {
        return moveTetrimino(rowOffset: 0, columnOffset: 1)
    }
    
    func moveteTriminoLeft() -> Bool {
        return moveTetrimino(rowOffset: 0, columnOffset: -1)
    }
    
    func moveTetrimino(rowOffset: Int, columnOffset: Int) -> Bool {
        
        guard let currentTetrimino = tetrimino else { return false }
        
        let newTetrimino = currentTetrimino.moveBy(row: rowOffset, column: columnOffset)
        if isValidTetrimino(testTetrimino: newTetrimino) {
            tetrimino = newTetrimino
            return true
        }
        
        return false
    }
    
    func rotateTetrimino(clockwise: Bool){
        guard let currentTetrimino = tetrimino else { return }
        
        let newTetrimino = currentTetrimino.rotate(clockwise: clockwise)
        if isValidTetrimino(testTetrimino: newTetrimino){
            tetrimino = newTetrimino
        }
    }
    
    func isValidTetrimino(testTetrimino: Tetrimino) -> Bool {
        for block in testTetrimino.blocks {
            let row = testTetrimino.origin.row + block.row
            if row < 0 || row >= nRows { return false }
            
            let column = testTetrimino.origin.column + block.column
            if column < 0 || column >= nColumns { return false }
            
            if gameBoard[column][row] != nil { return false }
        }
        
        return true
    }
    
    func placeTetrimino() {
        guard let currentTetrimino = tetrimino else {
            return
        }
        
        for block in currentTetrimino.blocks {
            let row = currentTetrimino.origin.row + block.row
            if row < 0 || row >= nRows { continue }
            
            let column = currentTetrimino.origin.column + block.column
            if column < 0 || column >= nColumns { continue }
            
            gameBoard[column][row] = GameBlock(blockType: currentTetrimino.blockType)
            
        }
        
        tetrimino = nil
    }
    
    func clearLines() -> Bool {
        var newBoard: [[GameBlock?]] = Array(repeating: Array(repeating: nil, count: nRows), count:nColumns)
        var boardUpdated = false
        var nextRowToCopy = 0
        
        for row in 0...nRows-1 {
            var clearLine = true
            for column in 0...nColumns-1 {
                clearLine = clearLine && gameBoard[column][row] != nil
            }
            if !clearLine {
                for column in 0...nColumns-1 {
                    newBoard[column][nextRowToCopy] = gameBoard[column][row]
                }
                nextRowToCopy += 1
            }
            boardUpdated = boardUpdated || clearLine
        }
        if boardUpdated {
            gameBoard = newBoard
        }
        return boardUpdated
    }

}

struct GameBlock{
    var blockType: BlockType
}

enum BlockType: CaseIterable {
    case i, t, o, j, l, s, z
}

struct Tetrimino {
    var origin:BlockLocation
    var blockType: BlockType
    var rotation: Int
    
    var blocks: [BlockLocation] {
        return Tetrimino.getBlocks(blockType: blockType, rotation: rotation)
    }
    
    func moveBy(row: Int, column:Int) -> Tetrimino {
        let newOrigin = BlockLocation(row: origin.row + row, column: origin.column + column)
        return Tetrimino(origin: newOrigin, blockType: blockType, rotation: rotation)
    }
    
    func rotate(clockwise: Bool) -> Tetrimino {
        return Tetrimino(origin: origin, blockType: blockType, rotation: rotation + (clockwise ? 1 : -1))
    }
    
    static func getBlocks(blockType: BlockType, rotation: Int = 0) -> [BlockLocation] {
        let allBlocks = getAllBlocks(blockType: blockType)
        
        var index = rotation % allBlocks.count
        if (index < 0) { index += allBlocks.count }
        return allBlocks[index]
    }
    
    static func getAllBlocks(blockType: BlockType) -> [[BlockLocation]] {
        switch blockType {
            case .i:
                return [[BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 0, column: 2)],
                        [BlockLocation(row: -1, column: 1), BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 1), BlockLocation(row: -2, column: 1)],
                        [BlockLocation(row: -1, column: -1), BlockLocation(row: -1, column: 0), BlockLocation(row: -1, column: 1), BlockLocation(row: -1, column: 2)],
                        [BlockLocation(row: -1, column: 0), BlockLocation(row: 0, column: 0), BlockLocation(row: 1, column: 0), BlockLocation(row: -2, column: 0)]]
            case .o:
                return [[BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 1), BlockLocation(row: 1, column: 0)]]
            case .t:
                return [[BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 0)],
                        [BlockLocation(row: -1, column: 0), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 0)],
                        [BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: -1, column: 0)],
                        [BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 1, column: 0), BlockLocation(row: -1, column: 0)]]
            case .j:
                return [[BlockLocation(row: 1, column: -1), BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1)],
                        [BlockLocation(row: 1, column: 0), BlockLocation(row: 0, column: 0), BlockLocation(row: -1, column: 0), BlockLocation(row: 1, column: 1)],
                        [BlockLocation(row: -1, column: 1), BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1)],
                        [BlockLocation(row: 1, column: 0), BlockLocation(row: 0, column: 0), BlockLocation(row: -1, column: 0), BlockLocation(row: -1, column: -1)]]
            case .l:
                return [[BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 1)],
                        [BlockLocation(row: 1, column: 0), BlockLocation(row: 0, column: 0), BlockLocation(row: -1, column: 0), BlockLocation(row: -1, column: 1)],
                        [BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: -1, column: -1)],
                        [BlockLocation(row: 1, column: 0), BlockLocation(row: 0, column: 0), BlockLocation(row: -1, column: 0), BlockLocation(row: 1, column: -1)]]
            case .s:
                return [[BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 1, column: 0), BlockLocation(row: 1, column: 1)],
                        [BlockLocation(row: 1, column: 0), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: -1, column: 1)],
                        [BlockLocation(row: 0, column: 1), BlockLocation(row: 0, column: 0), BlockLocation(row: -1, column: 0), BlockLocation(row: -1, column: -1)],
                        [BlockLocation(row: 1, column: -1), BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: -1, column: 0)]]
            case .z:
                return [[BlockLocation(row: 1, column: -1), BlockLocation(row: 1, column: 0), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1)],
                        [BlockLocation(row: 1, column: 1), BlockLocation(row: 0, column: 1), BlockLocation(row: 0, column: 0), BlockLocation(row: -1, column: 0)],
                        [BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: -1, column: 0), BlockLocation(row: -1, column: 1)],
                        [BlockLocation(row: 1, column: 0), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: -1), BlockLocation(row: -1, column: -1)]]
            }
        }
    
    static func createNewTetrimino(nRows: Int, nColumns: Int) -> Tetrimino {
        let blockType = BlockType.allCases.randomElement()!
        
        var maxRow = 0
        for block in getBlocks(blockType: blockType) {
            maxRow = max(maxRow, block.row)
        }
        
        let origin = BlockLocation(row: nRows - 1 - maxRow, column: (nColumns-1)/2)
        return Tetrimino(origin: origin, blockType: blockType, rotation: 0)
    }
}

struct BlockLocation {
    var row: Int
    var column: Int
}
