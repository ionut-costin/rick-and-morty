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
    @Environment(\.presentationMode) private var presentationMode
    @StateObject var viewModel: CharacterFilterViewModel

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
                    viewModel.updateFilter()
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
            Picker("Status", selection: $viewModel.status) {
                ForEach(viewModel.statuses, id: \.self) {
                    Text(($0 == .none ? "all" : $0.rawValue).capitalized)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    var genderView: some View {
        VStack(alignment: .leading) {
            Text("Gender")
            Picker("Gender", selection: $viewModel.gender) {
                ForEach(viewModel.genders, id: \.self) {
                    Text(($0 == .none ? "all" : $0.rawValue).capitalized)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    var speciesView: some View {
        VStack(alignment: .leading) {
            Text("Species")
            TextField("All species", text: $viewModel.species)
        }
    }
}
