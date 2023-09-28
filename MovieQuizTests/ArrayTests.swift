//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Admin on 21.09.2023.
//

import Foundation

import XCTest // не забывайте импортировать фреймворк для тестирования
@testable import MovieQuiz // импортируем наше приложение для тестирования

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
        // Given
        let array = ["a", "b", "c", "d"]
        // When
        let value = array[safe: 2]
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, "c")
    }
    
    func testGetValueOutOfRange() throws { // тест на взятие элемента по неправильному индексу
        let array = [1, 1, 2, 3, 5]
        // When
        let value = array[safe: 20]
        // Then
        XCTAssertNil(value)
    }
}
