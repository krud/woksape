//
//  TetrisGameView.swift
//  woksape
//
//  Created by Kelly Rudnicki on 3/23/20.
//  Copyright © 2020 Kelly Rudnicki. All rights reserved.
//

import SwiftUI

struct TetrisGameView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var tetrisGame = TetrisGameViewModel()
    
    var body: some View {
//        VStack{
//            HStack{
//                Button(action: {self.viewRouter.currentPage = "landing"}) {
//                    Text("< Back").foregroundColor(.cinder).padding()
//                }
//                Spacer()
//            }
//        }
        GeometryReader {
            (geometry: GeometryProxy) in
            self.drawBoard(boundingRect: geometry.size)
        }.gesture($tetrisGame.getMoveGesture())
        .gesture($tetrisGame.getRotateGesture())
    }
    
    func drawBoard(boundingRect: CGSize) -> some View {
        let columns = self.tetrisGame.nColumns
        let rows = self.tetrisGame.nRows
        let blocksize = min(boundingRect.width/CGFloat(columns), boundingRect.height/CGFloat(rows))
        
        let xoffset = (boundingRect.width - blocksize*CGFloat(columns))/2
        let yoffset = (boundingRect.height - blocksize*CGFloat(rows))/2
        let gameBoard = self.tetrisGame.gameBoard
        
        return ForEach(0...columns-1, id:\.self){(column:Int) in
            ForEach(0...rows-1, id:\.self){(row:Int) in
                Path { path in
                    let x = xoffset + blocksize * CGFloat(column)
                    let y = boundingRect.height - yoffset - blocksize*CGFloat(row+1)
                    
                    let rect = CGRect(x: x, y: y, width: blocksize, height: blocksize)
                    path.addRect(rect)
                }
                .fill(gameBoard[column][row].color)
            }
        }
    }
}

struct TetrisGameView_Previews: PreviewProvider {
    static var previews: some View {
        TetrisGameView()
    }
}
