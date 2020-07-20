//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Pablo Cornejo on 7/20/20.
//  Copyright © 2020 Pablo Cornejo Pierola. All rights reserved.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    @Binding var chosenPalette: String
    
    var body: some View {
        HStack {
            Stepper(onIncrement: { self.chosenPalette = self.document.palette(after: self.chosenPalette) },
                    onDecrement: { self.chosenPalette = self.document.palette(before: self.chosenPalette) },
                    label: { EmptyView() })
            Text(document.paletteNames[chosenPalette] ?? "")
        }
        .fixedSize(horizontal: true, vertical: false)   // To use only space offered to the view and not stretch to occupy any extra space.
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), chosenPalette: .constant(""))
    }
}
