import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameState: GameState
    @Namespace private var animation
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(.all)
            Image("CardTableTexture")
                .resizable()
                .ignoresSafeArea(.all)
            VStack {
                HStack {
                    Text(gameState.message)
                    Spacer()
                    VStack {
                        DeckView(deck: gameState.deck, namespace: animation)
                        Text("Deck")
                            .font(.custom("CaslonAntique", size: 22))
                            .foregroundStyle(.white)
                    }
                }
                .padding([.leading, .trailing], 10)
                ForEach(gameState.players) { player in
                    buildPlayerView(from: player)
                }
                Spacer()
                buildMyPlayingView(from: gameState.me)
                    .offset(y: 20)
            }
        }
        .compareCards(isPresented: $gameState.showCompareCards, cardNames: gameState.cardNamesToCompare, onTap: {
            gameState.syncPlayers()
            gameState.cardNamesToCompare.removeAll()
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
                Image(systemName: "square.fill")
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
        .overlay(RoundedRectangle(cornerRadius: 10).stroke().foregroundStyle(.white))
        .padding(.leading, 10)
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
    static var previews: some View {
        GameView()
            .environmentObject(GameState.testInit())
    }
}