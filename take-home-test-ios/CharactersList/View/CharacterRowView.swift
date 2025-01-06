//
//  CharacterRowView.swift
//  take-home-test-ios
//
//  Created by Amir Morsy on 06/01/2025.
//

import SwiftUI

struct CharacterRowView: View {
    let character: Character
    
    var body: some View {
        HStack(spacing: 16) {
            
            characterImageView
            
            VStack(alignment: .leading, spacing: 6) {
                Text(character.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.black)
                Text(character.species)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor(for: character.status))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor(for: character.status), lineWidth: 0.5)
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
    
    private var characterImageView: some View {
        AsyncImage(url: URL(string: character.image)) { image in
            image.resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } placeholder: {
            Image("photo")
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    func backgroundColor(for status: Status) -> Color {
        switch status {
        case .alive:
            return Color("AliveColor")
        case .dead:
            return Color("DeadColor")
        case .unknown:
            return Color.white
        }
    }

    func borderColor(for status: Status) -> Color {
        switch status {
        case .alive:
            return Color("AliveColor")
        case .dead:
            return Color("DeadColor")
        case .unknown:
            return Color.gray
        }
    }

}
