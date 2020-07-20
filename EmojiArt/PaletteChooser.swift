//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Pablo Cornejo on 7/20/20.
//  Copyright © 2020 Pablo Cornejo Pierola. All rights reserved.
//

import SwiftUI

struct PaletteChooser: View {
    var body: some View {
        HStack {
            Stepper(onIncrement: {  }, onDecrement: {  }) {
                EmptyView()
            }
            Text("Palette name") 
        }
        .fixedSize(horizontal: true, vertical: false)   // To use only space offered to the view and not stretch to occupy any extra space.
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser()
    }
}
