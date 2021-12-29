//
//  Filter.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 02.09.2021.
//

import SwiftUI

struct SearchParametersView: View {
    //
    // MARK: - Properties
    //
    @EnvironmentObject var searchEngine: SearchEngine
    @State var parameters = PokemonAPI.SearchParameters()
    
    // UI logic
    @State private var isFirstAppear = true
    @Environment(\.dismiss) private var dissmiss
    
    //
    // MARK: - Body
    //
    var body: some View {
        NavigationView{
            Form {
                // Search by name
                Section(header: Text("Name")) {
                    TextField("Name", text: $parameters.name)
                }
                // Filter by type
                Section(header: Text("Types")) {
                    Picker("Types", selection: $parameters.type) {
                        Text("All types").tag("")
                        ForEach(searchEngine.availableTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                }
            }
            .onAppear {
                // Load current search parameters
                if isFirstAppear {
                    parameters = searchEngine.parameters
                    isFirstAppear = false
                }
            }
            .navigationTitle("Search")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    clearButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    applyButton
                }
                
            }
        }
    }
    //
    // MARK: UI blocks
    //
    private var applyButton: some View {
        Button("Apply") {
            if parameters.isEmpty {
                searchEngine.resetResults()
            } else {
                searchEngine.changeSearchParameters(on: parameters)
            }
            dissmiss()
        }
    }
    
    private var clearButton: some View {
        Button("Clear") {
            searchEngine.resetResults()
            dissmiss()
        }
    }
}
//
// MARK: - Preview
//
struct SearchParametersView_Previews: PreviewProvider {
    static var previews: some View {
        SearchParametersView()
            .environmentObject(SearchEngine())
    }
}
