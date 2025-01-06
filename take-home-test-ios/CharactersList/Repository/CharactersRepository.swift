//
//  CharactersRepository.swift
//  take-home-test-ios
//
//  Created by Amir Morsy on 02/01/2025.
//

import Foundation
import Combine

protocol CharactersRepository {
    func getCharacters(request: RickandmortyAPIRequest) -> AnyPublisher<RickandmortyAPIResponse, Error>
}

class APICharactersRepository: CharactersRepository {
    func getCharacters(request: RickandmortyAPIRequest) -> AnyPublisher<RickandmortyAPIResponse, any Error> {
        return APIClient.performDecodableRequestURLSession(APIRouter.getCharacters(request: request))
    }
}
