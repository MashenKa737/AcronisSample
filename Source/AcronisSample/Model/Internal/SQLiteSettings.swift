//
//  Settings.swift
//  AcronisSample
//
//  Created by Maria Kataeva on 11/03/2019.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit
import SQLite

enum SQLiteSettings {

    static let databaseName = "notes_database.sqlite3"
    static let tableName = "notes"
    static let connectionTimeout = 1.0
    
    enum Columns {
        static let id = Expression<Int64>("id")
        static let text = Expression<String>("text")
        static let timeChanged = Expression<Date>("timeChanged")
        static let image = Expression<UIImage?>("image")
        static let sticker = Expression<String?>("sticker")
    }

}
