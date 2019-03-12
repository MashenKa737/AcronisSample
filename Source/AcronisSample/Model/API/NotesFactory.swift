//
//  NotesFactory.swift
//  AcronisSample
//
//  Created by Maria Kataeva on 07/03/2019.
//  Copyright © 2019 sample. All rights reserved.
//

public class NotesFactory {

    public enum RepositoryType {
        case sqLiteBased
    }

    public static func createRepository(type: RepositoryType = .sqLiteBased) -> NotesRepository {
        return SQLiteNotesRepository.shared
    }

}
