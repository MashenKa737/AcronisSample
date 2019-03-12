//
//  Note.swift
//  AcronisSample
//
//  Created by Maria Kataeva on 07/03/2019.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

public class Note {

    let id: Int64?
    public let text: String
    public let timeChanged: Date
    public let image: Data?
    public let sticker: Sticker?

    public convenience init(text: String, image: Data? = nil, sticker: Sticker? = nil) {
        self.init(id: nil, text: text, timeChanged: Date(), image: image, sticker: sticker)
    }

    init(id: Int64?, text: String, timeChanged: Date, image: Data? = nil, sticker: Sticker? = nil) {
        self.id = id
        self.text = text
        self.timeChanged = timeChanged
        self.image = image
        self.sticker = sticker
    }

    public enum Attributes: Hashable {
        case text(String)
        case image(Data?)
        case sticker(Sticker?)
    }

}
