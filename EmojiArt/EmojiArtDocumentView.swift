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
    @GestureState private var gestureZoomScale: CGFloat = 1.0 // can be any type that represents the data that will change with the gesture
    
    @State private var chosenPalette: String
    @State private var explainBackgroundPaste: Bool = false
    @State private var confirmBackgroundPaste: Bool = false
    
    init(document: EmojiArtDocument) {
        self.document = document
        _chosenPalette = State(wrappedValue: document.defaultPalette)
    }
    
    private var zoomScale: CGFloat {
        document.steadyStateZoomScale * gestureZoomScale
    }
    
    private var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil
    }
    
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (document.steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    var body: some View {
        VStack {
            HStack {
                PaletteChooser(document: document, chosenPalette: $chosenPalette)
                ScrollView(.horizontal) { 
                    HStack {
                        ForEach(chosenPalette.map(String.init), id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: self.defaultEmojiSize))
                                .onDrag { NSItemProvider(object: emoji as NSString) }
                        }
                    }
                }
            }
            
            GeometryReader { geometry in
                ZStack {
                    Color.white
                        .overlay(
                            OptionalImage(uiImage: self.document.backgroundImage)
                                .scaleEffect(self.zoomScale)
                                .offset(self.panOffset)
                        )
                        .gesture(self.doubleTapToZoom(in: geometry.size))
                    
                    if self.isLoading {
                        Image(systemName: "hourglass").imageScale(.large).spinning()
                    } else {
                        ForEach(self.document.emojis) { emoji in
                            Text(emoji.text)
                                .font(animatableWithSize: emoji.fontSize * self.zoomScale)
                                .position(self.position(for: emoji, in: geometry.size))
                        }
                    }
                }
                .clipped()
                .gesture(self.panGesture())
                .gesture(self.zoomGesture())
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onReceive(self.document.$backgroundImage) { image in
                    self.zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.width/2)
                    location = CGPoint(x: location.x - self.panOffset.width,
                                       y: location.y - self.panOffset.height)
                    location = CGPoint(x: location.x / self.zoomScale,
                                       y: location.y / self.zoomScale)
                    return self.drop(providers: providers, at: location)
                }
                .navigationBarItems(trailing: Button(action: {
                    if let url = UIPasteboard.general.url, url != self.document.backgroundURL {
                        self.confirmBackgroundPaste = true
                    } else {
                        self.explainBackgroundPaste = true
                    }
                }) {
                    Image(systemName: "doc.on.clipboard").imageScale(.large)
                        .alert(isPresented: self.$explainBackgroundPaste) {
                            Alert(title: Text("Paste Background"),
                                  message: Text("Copy the URL of an image to the clipboard and tap this button to make it the background of your document."),
                                  dismissButton: .default(Text("OK")))
                        }
                })
            }
        }
        .alert(isPresented: $confirmBackgroundPaste) {
            Alert(title: Text("Paste Background"),
                  message: Text("Replace your background with \(UIPasteboard.general.url?.absoluteString ?? "nothing")?."),
                  primaryButton: .default(Text("OK")) {
                      self.document.backgroundURL = UIPasteboard.general.url
                  },
                  secondaryButton: .cancel())
        }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture  {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    self.zoomToFit(self.document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomGesture() -> some Gesture  {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
                gestureZoomScale = latestGestureScale
            }
        .onEnded { self.document.steadyStateZoomScale *= $0 }
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
        }
        .onEnded {
            self.document.steadyStatePanOffset = self.document.steadyStatePanOffset + $0.translation / self.zoomScale
        }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.height > 0, size.width > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.document.steadyStateZoomScale = .zero
            self.document.steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * self.zoomScale, y: location.y * self.zoomScale)
        location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)
        location = CGPoint(x: location.x + self.panOffset.width,
                           y: location.y + self.panOffset.height)
        return location
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped: \(url)")
            self.document.backgroundURL = url
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}
