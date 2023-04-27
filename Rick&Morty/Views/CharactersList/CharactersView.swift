//
//  CharactersView.swift
//  Rick&Morty
//
//  Created by Ionut Andrei COSTIN on 27.04.2023.
//

import Combine
import SwiftUI
import RickMortySwiftApi

struct CharactersView: View {
    @StateObject var viewModel: CharactersViewModel
    let showFilter: PassthroughSubject<Bool, Never>

    var body: some View {
        ZStack {
            List(viewModel.characters, id: \.self, selection: $viewModel.characterSelected) { character in
                CharacterCardView(character: character)
                    .id(character)
            }
            emptyView
        }
        .navigationTitle("Rick & Morty")
        .searchable(text: $viewModel.search)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Filter") {
                    showFilter.send(true)
                }
            }
        }
        .onAppear {
            guard viewModel.characters.isEmpty else { return }
            viewModel.fetchCharacters()
        }
    }

    var emptyView: some View {
        Group {
            if !viewModel.isLoading, viewModel.characters.isEmpty {
                Text(viewModel.error?.localizedDescription ?? "No character was found!")
            } else {
                EmptyView()
            }
        }
        .padding(.horizontal)
    }
}
