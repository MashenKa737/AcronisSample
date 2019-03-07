//
//  NotesRepository.swift
//  AcronisSample
//
//  Created by Maria Kataeva on 07/03/2019.
//  Copyright © 2019 sample. All rights reserved.
//

public protocol NotesRepository {

    func listAllNotes() throws -> [Note]
    func saveNew(note: Note) throws
    func update(note: Note, attributes: Set<Note.Attributes>) throws
    func remove(note: Note) throws
    func removeAll() throws

}
