//
//  Note.swift
//  AcronisSample
//
//  Created by Maria Kataeva on 07/03/2019.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

public class Note {

    let id: Int32?
    public let text: String
    public let timeChanged: Date
    public let image: UIImage?
    public let sticker: Sticker?

    public convenience init(text: String, timeChanged: Date, image: UIImage? = nil, sticker: Sticker? = nil) {
        self.init(id: nil, text: text, timeChanged: timeChanged, image: image, sticker: sticker)
    }

    init(id: Int32?, text: String, timeChanged: Date, image: UIImage? = nil, sticker: Sticker? = nil) {
        self.id = id
        self.text = text
        self.timeChanged = timeChanged
        self.image = image
        self.sticker = sticker
    }

    public enum Attributes: Hashable {
        case text(String)
        case timeChanged(Date)
        case image(UIImage?)
        case sticker(Sticker?)
    }

}
