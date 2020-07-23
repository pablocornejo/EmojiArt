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
    @State private var showPaletteEditor: Bool = false
    
    var body: some View {
        HStack {
            Stepper(onIncrement: { self.chosenPalette = self.document.palette(after: self.chosenPalette) },
                    onDecrement: { self.chosenPalette = self.document.palette(before: self.chosenPalette) },
                    label: { EmptyView() })
            
            Text(document.paletteNames[chosenPalette] ?? "")
            
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture { self.showPaletteEditor = true }
                .sheet(isPresented: $showPaletteEditor) {
                    PaletteEditor(chosenPalette: self.$chosenPalette, isShowing: self.$showPaletteEditor)
                        .environmentObject(self.document)
                        .frame(minWidth: 300, minHeight: 500)
                }
        }
        .fixedSize(horizontal: true, vertical: false)   // To use only space offered to the view and not stretch to occupy any extra space.
    }
}

struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument
    @Binding var chosenPalette: String
    @Binding var isShowing: Bool
    @State private var paletteName: String = ""
    @State private var emojisToAdd: String = ""
    
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Palette Editor").font(.headline).padding()
                
                HStack {
                    Spacer()
                    Button(action: {
                        self.isShowing = false
                    }) { Text("Done") }.padding()
                }
            }
            
            Divider()
            
            Form {
                Section {
                    TextField("Palette Name", text: $paletteName, onEditingChanged: { began in
                        if !began {
                            self.document.renamePalette(self.chosenPalette, to: self.chosenPalette)
                        }
                    })
                    TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: { began in
                        if !began {
                            self.chosenPalette = self.document.addEmoji(self.emojisToAdd, toPalette: self.chosenPalette)
                            self.emojisToAdd = ""
                        }
                    })
                }
                
                Section(header: Text("Remove Emoji")) {
                    Grid(chosenPalette.map(String.init), id: \.self) { emoji in
                        Text(emoji).font(Font.system(size: self.fontSize))
                            .onTapGesture {
                                self.chosenPalette = self.document.removeEmoji(emoji, fromPalette: self.chosenPalette)
                            }
                    }
                    .frame(height: height)
                }
            }
        }
        .onAppear {
            self.paletteName = self.document.paletteNames[self.chosenPalette] ?? ""
        }
    }
    
    // MARK: - Drawing constants
    
    var height: CGFloat {
        CGFloat((chosenPalette.count - 1) / 6 * 70 + 70)
    }
    let fontSize: CGFloat = 40
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), chosenPalette: .constant(""))
    }
}
