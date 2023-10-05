//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Admin on 21.09.2023.
//

import Foundation

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        let array = ["a", "b", "c", "d"]
        let value = array[safe: 2]
        XCTAssertNotNil(value)
        XCTAssertEqual(value, "c")
    }
    
    func testGetValueOutOfRange() throws {
        let array = [1, 1, 2, 3, 5]
        let value = array[safe: 20]
        XCTAssertNil(value)
    }
}
