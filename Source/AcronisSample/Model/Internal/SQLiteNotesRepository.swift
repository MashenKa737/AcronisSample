//
//  SQLiteNotesRepository.swift
//  AcronisSample
//
//  Created by Maria Kataeva on 07/03/2019.
//  Copyright © 2019 sample. All rights reserved.
//

class SQLiteNotesRepository: NotesRepository {

    func listAllNotes() throws -> [Note] {
        throw NotesRepositoryError.runtimeError("Stub!")
    }

    func saveNew(note: Note) throws {
        throw NotesRepositoryError.runtimeError("Stub!")
    }

    func update(note: Note, attributes: Set<Note.Attributes>) throws {
        throw NotesRepositoryError.runtimeError("Stub!")
    }

    func remove(note: Note) throws {
        throw NotesRepositoryError.runtimeError("Stub!")
    }

    func removeAll() throws {
        throw NotesRepositoryError.runtimeError("Stub!")
    }

}
