//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Pablo Cornejo on 6/16/20.
//  Copyright © 2020 Pablo Cornejo Pierola. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(.system(size: self.defaultEmojiSize))
                    }
                }
            }
            .padding(.horizontal)
            
            Color.white
                .overlay(
                    Group {
                        if document.backgroundImage != nil {
                            Image(uiImage: document.backgroundImage!)
                        }
                    }
                )
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onDrop(of: ["public.image"], isTargeted: nil) { providers, location in
                    self.drop(providers: providers)
            }
        }
    }
    
    private func drop(providers: [NSItemProvider]) -> Bool {
        providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped: \(url)")
            self.document.setBackgroundURL(url)
        }
    }
    
    private let defaultEmojiSize: CGFloat = 40
}
