//
//  MazeGameView.swift
//  woksape
//
//  Created by Kelly Rudnicki on 3/23/20.
//  Copyright © 2020 Kelly Rudnicki. All rights reserved.
//

import SwiftUI

struct MazeGameView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {self.viewRouter.currentPage = "landing"}) {
                    Text("< Back").foregroundColor(.cinder).padding()
                }
                Spacer()
            }
            Text("MazeGame")
            Spacer()
        }
    }
}

struct MazeGameView_Previews: PreviewProvider {
    static var previews: some View {
        MazeGameView()
    }
}
