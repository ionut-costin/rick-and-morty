//
//  CharacterCardView.swift
//  Rick&Morty
//
//  Created by Ionut Andrei COSTIN on 27.04.2023.
//

import SwiftUI
import RickMortySwiftApi

struct CharacterCardView: View {
    @State var character: RMCharacterModel

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: character.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray)
            }
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text("Name: " + character.name)
                Text("Gender: " + character.gender)
                Text("Status: " + character.status)
                Text("Location: " + character.location.name)
            }
        }
        .padding(.vertical, 6)
    }
}
