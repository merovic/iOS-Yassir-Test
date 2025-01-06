//
//  take_home_test_iosTests.swift
//  take-home-test-iosTests
//
//  Created by Amir Ahmed on 02/01/2025.
//

import XCTest
import Combine
@testable import take_home_test_ios

final class CharacterListViewModelTests: XCTestCase {
    var viewModel: CharacterListViewModel!
    var mockRepository: MockCharactersRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCharactersRepository()
        viewModel = CharacterListViewModel(dataRepository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchCharactersSuccess() {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch characters updates the view model")
        mockRepository.mockResponse = RickandmortyAPIResponse(
            info: Info(count: 20, pages: 42, next: "https://rickandmortyapi.com/api/character?page=2"),
            results: [
                Character(id: 1, name: "Rick", status: .alive, species: "", type: "", gender: "", origin: Location(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [], url: "", created: ""),
                Character(id: 2, name: "Morty", status: .dead, species: "", type: "", gender: "", origin: Location(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [], url: "", created: "")]
        )
        
        // Act
        viewModel.fetchCharacters()
        
        // Assert
        viewModel.$characters
            .dropFirst() // Ignore the initial value
            .sink { characters in
                XCTAssertEqual(characters.count, 2)
                XCTAssertEqual(characters.first?.name, "Rick")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFilterCharacters() {
        // Arrange
        viewModel.characters = [
            Character(id: 1, name: "Rick", status: .alive, species: "", type: "", gender: "", origin: Location(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [], url: "", created: ""),
            Character(id: 2, name: "Morty", status: .dead, species: "", type: "", gender: "", origin: Location(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [], url: "", created: "")
        ]
        
        // Act
        viewModel.filterCharacters(by: .alive)
        
        // Assert
        XCTAssertEqual(viewModel.filteredCharacters.count, 1)
        XCTAssertEqual(viewModel.filteredCharacters.first?.name, "Rick")
    }
}

// MARK: - Mock Repository

final class MockCharactersRepository: CharactersRepository {
    var mockResponse: RickandmortyAPIResponse?
    var mockError: Error?
    
    func getUsers(request: RickandmortyAPIRequest) -> AnyPublisher<RickandmortyAPIResponse, Error> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        } else if let response = mockResponse {
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Empty().eraseToAnyPublisher()
        }
    }
}
