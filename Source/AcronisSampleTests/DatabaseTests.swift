//
//  DatabaseTests.swift
//  AcronisSampleTests
//
//  Created by Maria Kataeva on 12/03/2019.
//  Copyright © 2019 sample. All rights reserved.
//

import XCTest
import UIKit

@testable import AcronisSample

class DatabaseTests: XCTestCase {

    let emptyNote = Note(text: "")
    let savedNote = Note(id: 0, text: "text", timeChanged: Date.distantPast, sticker: .sad)
    let sampleImageData = UIColor.orange.image().pngData()!

    let repository = SQLiteNotesRepository.shared

    override func setUp() {
        openRepository()
    }

    func testOpenDestroy() {
        destroyRepository()
        openRepository()
        destroyRepository()
    }

    func testDestroyedBehavior() {
        destroyRepository()
        XCTAssertThrowsError(try repository.listAllNotes())
        XCTAssertThrowsError(try repository.saveNew(note: emptyNote))
        XCTAssertThrowsError(try repository.update(note: savedNote, attributes: []))
        XCTAssertThrowsError(try repository.remove(note: savedNote))
        XCTAssertThrowsError(try repository.removeAll())
        XCTAssertThrowsError(try repository.destroy())
    }

    func testRemoveAll() {
        XCTAssertNoThrow(try repository.removeAll())
        XCTAssertEqual(try? repository.listAllNotes(), [])
    }

    func testInsert() {
        XCTAssertNoThrow(try repository.saveNew(note: emptyNote))
        XCTAssertNoThrow(try repository.saveNew(note: savedNote))
        guard let notes = try? repository.listAllNotes() else {
            XCTFail("Get all failed")
            return
        }
        XCTAssertEqual(notes.count, 2)
        XCTAssertTrue(notes.contains { $0.contentEqual(with: emptyNote) })

        XCTAssertNoThrow(try repository.removeAll())
    }

    func testUpdate() {
        XCTAssertEqual(try? repository.listAllNotes(), [])

        XCTAssertThrowsError(try repository.update(note: savedNote, attributes: []))
        XCTAssertNoThrow(try repository.saveNew(note: emptyNote))
        XCTAssertThrowsError(try repository.update(note: emptyNote, attributes: []))
        guard let notesBeforeUpdate = try? repository.listAllNotes(),
            notesBeforeUpdate.count == 1,
            let reallyExistingNote = notesBeforeUpdate.first else {
                XCTFail("Get all failed")
                return
        }
        XCTAssertNoThrow(try repository.update(note: reallyExistingNote, attributes: []))
        XCTAssertNoThrow(try repository.update(note: reallyExistingNote, attributes: [.image(sampleImageData)]))
        guard let notes = try? repository.listAllNotes(),
            notes.count == 1,
            let note = notes.first else {
                XCTFail("Get all failed")
                return
        }
        XCTAssertEqual(note.image, sampleImageData)
        XCTAssertEqual(note.text, emptyNote.text)
        XCTAssertEqual(note.sticker, emptyNote.sticker)

        XCTAssertNoThrow(try repository.removeAll())
    }

    func testRemove() {
        XCTAssertEqual(try? repository.listAllNotes(), [])

        XCTAssertThrowsError(try repository.remove(note: emptyNote))
        XCTAssertThrowsError(try repository.remove(note: savedNote))

        XCTAssertNoThrow(try repository.saveNew(note: emptyNote))
        XCTAssertNoThrow(try repository.saveNew(note: savedNote))
        guard let notes = try? repository.listAllNotes(),
            notes.count == 2,
            let toDelete = notes.first,
            let toRemain = notes.last else {
                XCTFail("Get all failed")
                return
        }
        XCTAssertNoThrow(try repository.remove(note: toDelete))

        guard let resultNotes = try? repository.listAllNotes() else {
                XCTFail("Get all failed again")
                return
        }
        XCTAssertEqual(resultNotes, [toRemain])

        XCTAssertNoThrow(try repository.removeAll())
    }

    func openRepository() {
        do {
            try SQLiteNotesRepository.shared.open()
        } catch {
            XCTFail("Can't open repository")
            return
        }
    }

    func destroyRepository() {
        do {
            try SQLiteNotesRepository.shared.destroy()
        } catch {
            XCTFail("Can't destroy repository")
            return
        }
    }

}

extension Note: Equatable {

    public static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id &&
            lhs.text == rhs.text &&
            lhs.timeChanged == rhs.timeChanged &&
            lhs.image == rhs.image &&
            lhs.sticker == rhs.sticker
    }

    public func contentEqual(with note: Note) -> Bool {
        return text == note.text && image == note.image && sticker == note.sticker
    }

}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
