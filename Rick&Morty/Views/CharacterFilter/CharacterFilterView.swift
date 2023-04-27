//
//  CharacterFilterView.swift
//  Rick&Morty
//
//  Created by Ionut Andrei COSTIN on 27.04.2023.
//

import Combine
import SwiftUI
import RickMortySwiftApi

struct CharacterFilterView: View {
    private let statuses: [Status] = [Status.none, .alive, .dead]
    private let genders: [Gender] = [Gender.none, .male, .female, .genderless]

    @Environment(\.presentationMode) private var presentationMode
    @StateObject var viewModel: CharactersViewModel
    @State var filter: RMCharacterFilter

    init(viewModel: CharactersViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._filter = State(initialValue: viewModel.filter)
    }

    var body: some View {
        VStack(spacing: 8) {
            statusView
            genderView
            speciesView
        }
        .navigationTitle("Filter")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    viewModel.filter = filter
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .padding(.horizontal)
        .frame(maxHeight: .infinity, alignment: .top)
    }

    var statusView: some View {
        VStack(alignment: .leading) {
            Text("Status")
            Picker("Status", selection: $filter.status) {
                ForEach(statuses, id: \.self) {
                    Text(($0 == .none ? "all" : $0.rawValue).capitalized)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    var genderView: some View {
        VStack(alignment: .leading) {
            Text("Gender")
            Picker("Gender", selection: $filter.gender) {
                ForEach(genders, id: \.self) {
                    Text(($0 == .none ? "all" : $0.rawValue).capitalized)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    var speciesView: some View {
        VStack(alignment: .leading) {
            Text("Species")
            TextField("All species", text: $filter.species)
        }
    }
}
