//
//  CharacterListViewModel.swift
//  take-home-test-ios
//
//  Created by Amir Morsy on 02/01/2025.
//

import Foundation
import Combine

class CharacterListViewModel: ObservableObject {
    
    var cancellables = Set<AnyCancellable>()
    
    var hasNext: Bool = false
    
    var onUpdate = PassthroughSubject<Void, Never>()
    
    var filters: [Status] = [.alive, .dead, .unknown]
    
    @Published var selectedFilters: [Status] = []
    
    @Published var isLoading: Bool = false
    
    @Published var currentPage = 1
    
    @Published var characters: [Character] = []
    
    @Published var filteredCharacters: [Character] = [] {
        didSet {
            onUpdate.send()
        }
    }
    
    let dataRepository: CharactersRepository
    
    init(dataRepository: CharactersRepository = APICharactersRepository()) {
        self.dataRepository = dataRepository
    }
    
    func fetchCharacters() {
        isLoading = true
        dataRepository.getCharacters(request: RickandmortyAPIRequest(page: String(currentPage)))
            .compactMap({$0})
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    print("Publisher stopped observing")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: {[weak self] response in
                guard let self = self else { return }
                isLoading = false
                self.characters.append(contentsOf: response.results)
                self.filteredCharacters = self.characters
                self.hasNext = response.info.next != nil
               
                if self.hasNext {
                    self.currentPage += 1
                }
                
                if !selectedFilters.isEmpty {
                    self.filterCharacters()
                }
            }).store(in: &cancellables)
    }
        
    func filterCharacters() {
        filteredCharacters = characters.filter { selectedFilters.contains($0.status) }
        if selectedFilters.isEmpty {
            filteredCharacters = characters
        }
    }
}
