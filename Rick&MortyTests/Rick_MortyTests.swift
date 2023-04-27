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

    var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        subscriptions = []
    }

    func testCharactersFetching() throws {
        let api = MainAPI()
        let filterSubject = CurrentValueSubject<RMCharacterFilter, Never>(RMCharacterFilter())
        let characterSelectedSubject = PassthroughSubject<RMCharacterModel, Never>()

        let charactersViewModel = CharactersViewModel(api: api,
                                                      filterSubject: filterSubject,
                                                      characterSelectedSubject: characterSelectedSubject)

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

        XCTAssert(!results.isEmpty, "Characters fetch failed")
    }

}
