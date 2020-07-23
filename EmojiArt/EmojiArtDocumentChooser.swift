//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by Pablo Cornejo on 7/23/20.
//  Copyright © 2020 Pablo Cornejo Pierola. All rights reserved.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore // could be @ObservedObject too
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.documents) { document in
                    NavigationLink(destination: EmojiArtDocumentView(document: document).navigationBarTitle(self.store.name(for: document))) {
                        Text(self.store.name(for: document))
                    }
                }
            }
            .navigationBarTitle(store.name )
            .navigationBarItems(leading: Button(action: {
                self.store.addDocument()
            }) {
                Image(systemName: "plus").imageScale(.large)
            })
        }
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
