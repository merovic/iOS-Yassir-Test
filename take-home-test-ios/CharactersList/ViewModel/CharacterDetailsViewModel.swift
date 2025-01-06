//
//  CharacterDetailsViewModel.swift
//  take-home-test-ios
//
//  Created by Amir Morsy on 02/01/2025.
//

import Foundation
import Combine

class CharacterDetailsViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var character: Character
        
    init(character: Character) {
        self.character = character
    }
}
