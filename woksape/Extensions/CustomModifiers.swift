//
//  CustomModifiers.swift
//  woksape
//
//  Created by Kelly Rudnicki on 3/23/20.
//  Copyright © 2020 Kelly Rudnicki. All rights reserved.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(Color.cinder)
            .padding()
            .frame(width: UIScreen.main.bounds.width - 170, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 15, style:   .circular).fill(Color.whitesmoke))
            .padding(.bottom, 8)
    }
}

extension View {
    func customButton() -> ModifiedContent<Self, ButtonModifier> {
        return modifier(ButtonModifier())
    }
}
