//
//  SQLiteNotesRepository.swift
//  AcronisSample
//
//  Created by Maria Kataeva on 07/03/2019.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation
import SwiftyBeaver

class SQLiteNotesRepository: NotesRepository {

    static let shared = SQLiteNotesRepository()

    private var databaseValue: SQLiteNotesDatabase!
    private let queue = DispatchQueue(label: "SQLiteRepositoryQueue", attributes: .concurrent)

    private var database: SQLiteNotesDatabase! {
        get {
            return queue.sync {
                return databaseValue
            }
        }
        set(value) {
            queue.async(flags: .barrier) { [unowned self] in
                self.databaseValue = value
            }
        }
    }

    private init() { }

    func open() throws {
        if database != nil {
            return
        }
        //TODO: Find out how to create file in directory hirarchy and provide path in init
        guard let databasePath = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(SQLiteSettings.databaseName) else {
                throw NotesRepositoryError.runtimeError("Directory is inaccessible")
        }
        guard let database = SQLiteNotesDatabase(path: databasePath) else {
            throw NotesRepositoryError.runtimeError("Cannot open file at path: \(databasePath)")
        }
        self.database = database
    }

    func listAllNotes() throws -> [Note] {
        try checkWasInitialized()
        return try database.selectAll()
    }

    func saveNew(note: Note) throws {
        try checkWasInitialized()
        try database.create(note: note)
    }

    func update(note: Note, attributes: Set<Note.Attributes>) throws {
        try checkWasInitialized()
        if note.id == nil {
            SwiftyBeaver.error("Trying to update not existing entity")
            throw NotesRepositoryError.queryError
        }
        try database.update(id: note.id!, with: attributes)
    }

    func remove(note: Note) throws {
        try checkWasInitialized()
        if note.id == nil {
            SwiftyBeaver.error("Trying to delete not existing entity")
            throw NotesRepositoryError.queryError
        }
        try database.remove(id: note.id!)
    }

    func removeAll() throws {
        try checkWasInitialized()
        try database.clear()
    }

    func destroy() throws {
        try checkWasInitialized()
        try FileManager.default.removeItem(at: database.path)
        database = nil
    }

    private func checkWasInitialized() throws {
        if database == nil {
            let error = NotesRepositoryError.invalidUsage
            SwiftyBeaver.error(error)
            throw error
        }
    }
}
