//
//  Constants.swift
//  CombineNetworking
//
//  Created by Amir Ahmed on 11/12/2023.
//

import Foundation

enum RemoteServers {
    case ProductionServer
    case StagingServer
}

extension RemoteServers: ServerBase {
    var value: String {
        switch self {
        case .ProductionServer: return "https://rickandmortyapi.com/api/"
        case .StagingServer: return "https://staging.rickandmortyapi.com/api/"
        }
    }
}

protocol ServerPath {
    var value: String { get }
}

protocol ServerBase {
    var value: String { get }
}
