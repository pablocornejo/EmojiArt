//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Pablo Cornejo on 7/4/20.
//  Copyright © 2020 Pablo Cornejo Pierola. All rights reserved.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if self.uiImage != nil {
                Image(uiImage: self.uiImage!)
            }
        }
    }
}
