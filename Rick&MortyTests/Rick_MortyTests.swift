//
//  Rick_MortyTests.swift
//  Rick&MortyTests
//
//  Created by Ionut Andrei COSTIN on 27.04.2023.
//

import XCTest
import Combine
import RickMortySwiftApi
@testable import Rick_Morty

final class Rick_MortyTests: XCTestCase {

    var charactersViewModel: CharactersViewModel!

    var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        charactersViewModel = CharactersViewModel(api: CharactersAPI())
    }

    override func tearDownWithError() throws {
        charactersViewModel = nil
        subscriptions = []
    }

    func testCharactersFetching() throws {
        let expectation = self.expectation(description: #function)

        var results: [RMCharacterModel] = []

        charactersViewModel.$characters
            .dropFirst()
            .sink { characters in
                results = characters
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        charactersViewModel.fetchCharacters()

        waitForExpectations(timeout: 2, handler: nil)

        XCTAssert(results.count == 826, "Characters fetch failed!")
    }

    func testCharactersFilter() {
        let expectation = self.expectation(description: #function)

        var results: [RMCharacterModel] = []

        charactersViewModel.$characters
            .dropFirst()
            .sink { characters in
                results = characters
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        charactersViewModel.filter = RMCharacterFilter(status: .alive)

        waitForExpectations(timeout: 2, handler: nil)

        print(results.count)
        XCTAssert(results.count == 439, "Characters filter failed!")
    }

}
