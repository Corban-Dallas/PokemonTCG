//
//  SearchEngine.swift
//  PokemonTCG
//
//  Created by Григорий Кривякин on 26.12.2021.
//

import Foundation
import OrderedCollections

@MainActor class SearchEngine: ObservableObject {
    //
    // MARK: - Properties
    //
    @Published var results = OrderedSet<Card>()
    @Published var status: SearchStatus = .idle
    private(set) var availableTypes: OrderedSet<String> = ["Fire", "Water"]
    
    private var pagesFetched: Int = 0
    private(set) var parameters = PokemonAPI.SearchParameters()
    //
    // MARK: - Constants
    //
    private let defaultPageSize = 25
    //
    // MARK: - Initialization
    //
    init() {
        Task {
            if let types = await PokemonAPI.shared.fetchTypes() {
                self.availableTypes = OrderedSet(types)
            }
        }
    }
    //
    // MARK: - Class methods
    //
    public func changeSearchParameters(on parameters: PokemonAPI.SearchParameters) {
        // Prepear to new search
        self.pagesFetched = 0
        self.results = []
        self.parameters = parameters
        self.status = .canLoadNextPage
    }
    
    public func resetResults() {
        self.pagesFetched = 0
        self.results = []
        self.status = .idle
    }
    
    public func fetchNextPage() async {
        // Check if all cards already fetched
        if status == .complite { return }
        
        // Fetch cards
        guard let cards = await PokemonAPI.shared.fetchCards(page: pagesFetched + 1,
                                                      pageSize: defaultPageSize,
                                                      filter: self.parameters) else {
            status = .error
            return
        }
        if cards.isEmpty && pagesFetched == 0 {
            // Nothing found
            status = .nothingFound
            return
        } else if cards.count < defaultPageSize {
            // All cards are fetched
            status = .complite
        }
        
        pagesFetched += 1
        results.append(contentsOf: cards)
    }
    //
    // MARK: -
    //
    enum SearchStatus {
        case idle, complite, nothingFound, canLoadNextPage, error
    }
}
