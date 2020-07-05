//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Pablo Cornejo on 6/16/20.
//  Copyright © 2020 Pablo Cornejo Pierola. All rights reserved.
//

import Foundation

struct EmojiArt: Codable {
    var backgroundURL: URL?
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable, Codable {
        let text: String
        var x: Int // offset from center
        var y: Int // offset from center
        var size: Int
        let id: Int
        
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    private var uniqueEmojiID = 0
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiID))
        uniqueEmojiID += 1
    }
}
