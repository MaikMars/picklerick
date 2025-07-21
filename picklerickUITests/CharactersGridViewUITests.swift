//
//  CharactersGridViewUITests.swift
//  picklerickUITests
//
//  Created by Miki on 21/7/25.
//

import Foundation

import XCTest

final class CharactersGridViewUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testCharactersGrid_showsCharacterList() {
        // Given
        let charactersTitle = app.navigationBars["Characters"].staticTexts["Characters"]
        
        // Then
        XCTAssertTrue(charactersTitle.waitForExistence(timeout: 5), "Characters screen should appear")

        let firstCell = app.scrollViews.otherElements.children(matching: .other).element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "Expected at least one character cell to appear")
    }

    func testFiltersButton_opensFiltersView() {
        // Given
        app/*@START_MENU_TOKEN@*/.buttons["slider.horizontal.3"]/*[[".otherElements",".buttons[\"Edit\"]",".buttons[\"slider.horizontal.3\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
      
       //Then
        let filtersButton =  app/*@START_MENU_TOKEN@*/.buttons["Aplicar filtros"]/*[[".otherElements.buttons[\"Aplicar filtros\"]",".buttons[\"Aplicar filtros\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(filtersButton.waitForExistence(timeout: 3), "Filters view should be visible after tap")
    }
    
}
