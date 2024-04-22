import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameState: GameState
    @Namespace private var animation
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(.all)
            Image("CardTableBackground")
                .resizable()
                .ignoresSafeArea(.all)
            VStack {
                HStack {
                    VStack {
                        DeckView(deck: gameState.outCardHand, namespace: animation)
                        Text("Excluded")
                            .font(.custom("CaslonAntique", size: 22))
                            .foregroundStyle(.white)
                    }
                    Text(String("Round: \(gameState.gameLog.roundLogs.count)"))
                        .font(.custom("CaslonAntique", size: 22))
                    .padding(.leading)
                    .foregroundStyle(.white)
                    Spacer()
                    buildLootPileView(namespace: animation, game: gameState)
                    HStack {
                        VStack {
                            DeckView(deck: gameState.deck, namespace: animation)
                            Text("Deck")
                                .font(.custom("CaslonAntique", size: 22))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding([.leading, .trailing], 10)
                ForEach(gameState.players) { player in
                    buildPlayerView(from: player)
                }
                Spacer()
                buildMyPlayingView(from: gameState.me)
                    .confettiCannon(counter: $gameState.me.counter, num: 15)
                    .offset(y: 20)
            }
        }
        .compareCards(isPresented: $gameState.showCompareCards, cardNames: gameState.cardNamesToCompare, onTap: {
            gameState.syncPlayers()
            gameState.cardNamesToCompare.removeAll()
        })
        .winnerView(isPresented: $gameState.showWinningView, card: gameState.winningCard, onTap: {
            gameState.unsubscribeFromGameChannels()
            gameState.displayViewController.changeView(view: .homeMenuView)
        })
        .viewSingleCard(isPresented: $gameState.showPeekCard, card: gameState.cardToPeek, onTap: {
            gameState.syncPlayers()
        })
        .showCard(isPresented: $gameState.showCard, show: gameState.cardToShow)
        .showPlayCard(isPresented: $gameState.playCard,
                      show: gameState.cardToShow,
                      game: gameState,
                      myTurn: $gameState.myTurn
        )
        .showRules()
        .withGameLog(for: gameState.gameLog)
        .onAppear(perform: {
            gameState.subscribeToGameChannels()
            gameState.syncPlayers()
        })
        .environmentObject(gameState)
    }
    @ViewBuilder
    private func buildPlayerView(from player: GamePlayer) -> some View {
        HStack {
            VStack {
                HandView(hand: player.getHand(type: .holding),
                         player: player,
                         namespace: animation,
                         onCardTap: nil,
                         cardSize: .small
                )
            }
            VStack {
                HandView(hand: player.getHand(type: .discard),
                         player: player,
                         namespace: animation,
                         onCardTap: { gameState.showCard(card: $0)},
                         cardSize: .large)
            }
            Spacer()
        }
        .padding(.leading, 10)
    }
    @ViewBuilder
    private func buildMyPlayingView(from player: GamePlayer) -> some View {
        VStack {
            HandView(hand: player.getHand(type: .discard),
                    player: player,
                    isMe: true,
                    namespace: animation,
                    onCardTap: { gameState.showCard(card: $0) },
                    cardSize: .small)
            .overlay(alignment: .topLeading) {
                Text("Discard")
                    .font(.custom("CaslonAntique", size: 22))
                    .foregroundStyle(.white)
                    .padding([.leading, .top])
            }
            .overlay(alignment: .bottomLeading) {
                ZStack {
                    if player.hasCoin {
                        Image("lootCoin")
                            .matchedGeometryEffect(id: "coin", in: animation)
                    }
                    Image(systemName: "circle.fill")
                        .padding([.bottom, .leading], 3)
                        .foregroundStyle(.yellow)
                        .font(.title)
                        .overlay(alignment: .center) {
                            Text(String(player.numberOfWins))
                                .font(.custom("CaslonAntique", size: 20))
                                .foregroundStyle(.black.opacity(0.8))
                                .padding([.bottom, .leading], 3)
                        }
                }
            }
            .overlay(alignment: .topTrailing) {
                if player.isSafe {
                    Image(systemName: "shield.fill")
                        .foregroundStyle(Color.blue.opacity(0.7))
                        .font(.system(size: 30))
                        .padding([.top, .trailing], 8)
                }
            }
            HandView(
                hand: player.getHand(type: .holding),
                player: player,
                isMe: true,
                namespace: animation,
                onCardTap: { gameState.playCard(card: $0) },
                cardSize: .large
            )
            .shadow(color: .yellow, radius: gameState.myTurn ? 10 : 0)
        }
        .overlay(RoundedRectangle(cornerRadius: 10).stroke().foregroundStyle(.white)
        )
        .overlay {
            if player.isOut {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(.red.opacity(0.40))
                    Image(systemName: "xmark")
                        .font(.system(size: 75))
                        .foregroundStyle(.red)
                }
            }
        }
        .padding(.leading, 10)
    }
    @ViewBuilder
    private func buildLootPileView(namespace: Namespace.ID, game: GameState) -> some View {
        ZStack {
            if game.hasCoin {
                Image("lootCoin")
                    .matchedGeometryEffect(id: "coin", in: namespace)
            }
            Image("gameLootPile")
        }
    }
    // MARK: Private functions
    private func changeStatus() {
        let thingToChange = Bool.random()
        if thingToChange {
            gameState.players.first!.isOut = false
            gameState.players.first!.isSafe = true
        } else {
            gameState.players.first!.isSafe = false
            gameState.players.first!.isOut = true
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var game: GameState = GameState.testInit()
    static var previews: some View {
        ZStack {
            GameView()
            .environmentObject(game)
            CustomButton(text: "try me") {
                let card = Card(number: 4)
                game.deck.cards.append(card)
                withAnimation {
                    guard let index = game.deck.cards.firstIndex(of: card) else {
                        print("Could not find card in deck!")
                        return
                    }
                    let dealtCard = game.deck.cards.remove(at: index)
                    game.outCardHand.cards.append(dealtCard)
                }
            }
        }
    }
}
