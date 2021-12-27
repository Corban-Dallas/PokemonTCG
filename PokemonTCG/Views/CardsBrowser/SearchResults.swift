//
//  SearchResults.swift
//  PokemonTCG
//
//  Created by Григорий Кривякин on 26.12.2021.
//

import SwiftUI

struct SearchResults: View {
    @EnvironmentObject var searchEngine: SearchEngine
    
    var body: some View {
        switch searchEngine.status {
        case .nothingFound:
            Text("Nothing found")
        case .error:
            Text("Some error occured")
        case .idle:
            Text("Waiting for request")
        default:
            CardScrollGrid(cards: $searchEngine.results,
                      onScrolledAtBottom: searchEngine.fetchNextPage,
                      loadingIsAvailable: searchEngine.status == .canLoadNextPage)
        }
    }
}
//
// MARK: - Preview
//
struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults()
            .environmentObject(SearchEngine())
    }
}
