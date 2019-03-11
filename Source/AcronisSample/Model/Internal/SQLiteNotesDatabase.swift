//
//  SQLiteNotesDatabase.swift
//  AcronisSample
//
//  Created by Maria Kataeva on 11/03/2019.
//  Copyright © 2019 sample. All rights reserved.
//

import UIKit

import SQLite
import SwiftyBeaver

class SQLiteNotesDatabase {

    //From docs: "Every Connection comes equipped with its own serial queue for statement execution and can be safely accessed across threads. Threads that open transactions and savepoints will block other threads from executing statements while the transaction is open."
    private let connection: Connection
    private let table: Table

    init?(path: String) {
        do {
            connection = try Connection(.uri(path), readonly: false)
        } catch {
            SwiftyBeaver.warning("Connection to database on path \(path) cannot be open: \(error)")
            return nil
        }
        table = Table(Note.tableName)
        do {
            try connection.run(table.create(ifNotExists: true) { Note.formCreateStatement(table: $0) })
        } catch {
            SwiftyBeaver.warning("Cannot open or create table: \(error)")
            return nil
        }
    }

    func selectAll() throws -> [Note] {
        return try connection.prepare(table).map { try Note.parseSelectStep($0) }
    }

    func create(note: Note) throws {
        try connection.run(note.formInsert(to: table))
    }

    func update(id: Int64, with attributes: Set<Note.Attributes>) throws {
        let chosen = table.filter(SQLiteSettings.Columns.id == id)
        var updateStatements: [SQLite.Setter] = attributes.map {
            switch $0 {
            case .text(let text):
                return SQLiteSettings.Columns.text <- text
            case .image(let image):
                return SQLiteSettings.Columns.image <- image
            case .sticker(let sticker):
                return SQLiteSettings.Columns.sticker <- sticker?.value
            }
        }
        updateStatements.append(SQLiteSettings.Columns.timeChanged <- Date())
        try connection.run(chosen.update(updateStatements))
    }

    func remove(id: Int64) throws {
        let chosen = table.filter(SQLiteSettings.Columns.id == id)
        try connection.run(chosen.delete())
    }

    func clear() throws {
        try connection.run(table.delete())
    }

}

fileprivate extension Note {

    static let tableName = "notes"

    static func formCreateStatement(table: TableBuilder) {
        table.column(SQLiteSettings.Columns.id, primaryKey: true)
        table.column(SQLiteSettings.Columns.text)
        table.column(SQLiteSettings.Columns.timeChanged)
        table.column(SQLiteSettings.Columns.image)
        table.column(SQLiteSettings.Columns.sticker)
    }

    static func parseSelectStep(_ step: Row) throws -> Note {
        guard let id = try? step.get(SQLiteSettings.Columns.id),
            let text = try? step.get(SQLiteSettings.Columns.text),
            let timeChanged = try? step.get(SQLiteSettings.Columns.timeChanged),
            let image = try? step.get(SQLiteSettings.Columns.image),
            let sticker = try? step.get(SQLiteSettings.Columns.sticker) else {
                SwiftyBeaver.error("Error in value conversion")
                throw NotesRepositoryError.parseError
        }

        var stickerValue: Sticker? = nil
        if sticker != nil {
            stickerValue = Sticker.fromRawValue(sticker!)
            if stickerValue == nil {
                SwiftyBeaver.info("Unknown sticker format. Processed as nil.")
            }
        }

        return Note(id: id, text: text, timeChanged: timeChanged, image: image, sticker: stickerValue)
    }

    func formInsert(to table: Table) -> Insert {
        return table.insert(
            SQLiteSettings.Columns.text <- text,
            SQLiteSettings.Columns.timeChanged <- timeChanged,
            SQLiteSettings.Columns.image <- image,
            SQLiteSettings.Columns.sticker <- sticker?.value
        )
    }

}

fileprivate extension Sticker {

    static func fromRawValue(_ value: String) -> Sticker? {
        switch value {
        case "attention":
            return .attention
        case "grinning":
            return .grinning
        case "smiling":
            return .smiling
        case "astonished":
            return .astonished
        case "angry":
            return .angry
        case "sad":
            return .sad
        default:
            return nil
        }
    }
    
    var value: String {
        switch self {
        case .attention:
            return "attention"
        case .grinning:
            return "grinning"
        case .smiling:
            return "smiling"
        case .astonished:
            return "astonished"
        case .angry:
            return "angry"
        case .sad:
            return "sad"
        }
    }

}

extension UIImage: Value {
    public class var declaredDatatype: String {
        return Blob.declaredDatatype
    }
    public class func fromDatatypeValue(_ blobValue: Blob) -> UIImage {
        return UIImage(data: Data(bytes: blobValue.bytes))!
    }
    public var datatypeValue: Blob {
        return Blob(bytes: Array(pngData() ?? Data()))
    }
}

