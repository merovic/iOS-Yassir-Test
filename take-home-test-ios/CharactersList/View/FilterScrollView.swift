//
//  FilterScrollView.swift
//  take-home-test-ios
//
//  Created by Amir Morsy on 06/01/2025.
//

import SwiftUI

struct FilterScrollView: View {
    @ObservedObject var viewModel: CharacterListViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.filters, id: \.self) { filter in
                    FilterButton(filter: filter, includedInFilter: viewModel.selectedFilters.contains(filter)) {
                        if viewModel.selectedFilters.contains(filter) {
                            viewModel.selectedFilters.remove(at: viewModel.selectedFilters.firstIndex(of: filter)!)
                        } else{
                            viewModel.selectedFilters.append(filter)
                        }
                        
                        viewModel.filterCharacters()
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 60)
    }
}

struct FilterButton: View {
    let filter: Status
    let includedInFilter: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(filter.rawValue)
                .padding()
                .foregroundColor(includedInFilter ? .white : .black)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(includedInFilter ? Color.brown : Color.white)
                        .shadow(color: .gray, radius: 0.5, x: 0, y: 0.5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(SwiftUI.Color(includedInFilter ? .white : .gray), lineWidth: 1)
                )
        }
    }
}

