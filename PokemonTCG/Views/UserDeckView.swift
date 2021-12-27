//
//  UserDeckView.swift
//  PokemonLibrary
//
//  Created by Григорий Кривякин on 26.09.2021.
//

import SwiftUI

struct UserDeckView: View {
    // MARK: - Properties
    // Data source
    @Binding var deck: UserDeck
    @EnvironmentObject var deckStore: UserDecksStore
    
    // UI logic
    @State var editMode: EditMode = .inactive
    @State var selection: [Card] = []
    
    @Namespace var animation
    //
    // MARK: - Constants
    //
    let gridItems = [GridItem(.adaptive(minimum: Constants.cardSize))]
    static let checkmarkSize: CGFloat = 30
    //
    // MARK: - Body
    //
    var body: some View {
        ScrollView {
            // Edit deck name
            if editMode.isEditing {
                TextField("Deck name", text: $deck.name).font(.title)
            }
            // Cards grid
            LazyVGrid(columns: gridItems) {
                ForEach($deck.cards) { card in
                    ZStack(alignment: .bottomTrailing ) {
                        // Card
                        CardView(card: card.wrappedValue)
                            .contextMenu {
                                Button("Remove", role: .destructive) {
                                    withAnimation {
                                        deck.removeCard(card.wrappedValue)
                                    }
                                }
                            }
                            .onTapGesture {
                                if editMode.isEditing {
                                    selectCard(card.wrappedValue)
                                }
                            }
                        // Selection checkmark
                        if editMode.isEditing, selection.contains(card.wrappedValue) {
//                            Rectangle()
//                                .foregroundColor(.black)
//                                .opacity(0.5)
                            Self.checkmark
                                .padding()
                            
                        }
                        
                    }
                }
            }
        }
        .navigationTitle(editMode.isEditing ? "" : deck.name)
        .padding(.horizontal)
        .toolbar {
            editButton
            if selection.count > 0 {
                removeCardsButton
            }
            removeCardsButton
        }
    }
    //
    // MARK: - UI blocks
    //
    static let checkmark: some View = {
        Image(systemName: "checkmark.circle.fill")
            .resizable()
            .frame(width: checkmarkSize, height: checkmarkSize)
            .foregroundColor(.blue)
            .background(Circle().foregroundColor(.black))
            .shadow(color: .black, radius: 2)
    }()
    
    private var editButton: some View {
        Button {
            withAnimation {
                editMode.toggle()
            }
            if editMode == .inactive {
                selection.removeAll()
            }
        } label: {
            Text(editMode.title)
        }
    }
    
    private var removeCardsButton: some View {
        Button(role: .destructive) {
            withAnimation {
                selection.forEach {
                    deck.removeCard($0)
                }
            }
            selection.removeAll()
        } label: {
            Image(systemName: "trash")
                .resizable()
            //Label("Remove", systemImage: "trash")
        }
    }
    //
    // MARK: - User intents
    //
    // Select or unselect card
    private func selectCard(_ card: Card) {
        if let index = selection.firstIndex(of: card)  {
            selection.remove(at: index)
        } else {
            selection.append(card)
        }
    }
}
