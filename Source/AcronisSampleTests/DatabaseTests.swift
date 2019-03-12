//
//  DatabaseTests.swift
//  AcronisSampleTests
//
//  Created by Maria Kataeva on 12/03/2019.
//  Copyright © 2019 sample. All rights reserved.
//

import XCTest
@testable import AcronisSample

class DatabaseTests: XCTestCase {

    func testExample() {
        openRepository()
        destroyRepository()
        openRepository()
        destroyRepository()
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
