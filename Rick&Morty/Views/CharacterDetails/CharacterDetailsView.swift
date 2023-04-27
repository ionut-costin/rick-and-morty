//
//  CharacterDetailsView.swift
//  Rick&Morty
//
//  Created by Ionut Andrei COSTIN on 27.04.2023.
//

import SwiftUI
import RickMortySwiftApi

struct CharacterDetailsView: View {
    @State var character: RMCharacterModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                VStack {
                    AsyncImage(url: URL(string: character.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray)
                    }
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Name: " + character.name)
                        Text("Gender: " + character.gender)
                        Text("Status: " + character.status)
                        Text("Location: " + character.location.name)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Text("Episodes")
                ForEach(character.episode, id: \.self) { episode in
                    Text(episode)
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Character Details")
        .padding(.all, 0)
    }
}
