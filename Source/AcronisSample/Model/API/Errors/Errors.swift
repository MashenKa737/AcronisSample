//
//  Errors.swift
//  AcronisSample
//
//  Created by Maria Kataeva on 07/03/2019.
//  Copyright © 2019 sample. All rights reserved.
//

public enum NotesRepositoryError: Error {
    case runtimeError(String)
    case invalidUsage
    case queryError
    case parseError
}
