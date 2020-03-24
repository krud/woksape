//
//  ContentView.swift
//  woksape
//
//  Created by Kelly Rudnicki on 3/23/20.
//  Copyright © 2020 Kelly Rudnicki. All rights reserved.
//

import SwiftUI
import Combine

class ViewRouter: ObservableObject {
    let objectWillChange = PassthroughSubject<ViewRouter,Never>()
    
    var currentPage: String = "landing" {
        didSet {
            objectWillChange.send(self)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
        
    var body: some View {
        VStack {
            if viewRouter.currentPage == "landing" {
                LandingView()
            }
            if viewRouter.currentPage == "maze" {
                MazeGameView()
            }
            if viewRouter.currentPage == "tetris" {
                TetrisGameView()
            }
        }.background(Image("background"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
