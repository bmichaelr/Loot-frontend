import SwiftUI

struct GameView: View {
    @StateObject var game: GameState
    @State var playerViews: [PlayerView] = []
    @State var localPlayer: PlayerView?
    @Namespace private var animation
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
        ZStack {
            DeckView(hand: game.deck, namespace: animation, onCardTap: { card in
                // game.animationHandler.dealToAll(game: game)
                game.animationHandler.showWinner(player: game.gamePlayers.first!)
            })
            .position(CGPoint(x: UIScreen.main.bounds.width - 70, y: 50))
            VStack {
                ForEach(playerViews.indices, id: \.self) { index in
                    playerViews[index]
                        .frame(width: UIScreen.main.bounds.width, height: 150, alignment: .leading)
                }
            }.position(CGPoint(x: UIScreen.main.bounds.width / 2, y: 150))
                .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 2)
            localPlayer
        }.background(Image("woodbackground"))
            .onAppear {
                createPlayerViews()
                game.subscribeToGameChannels()
                viewModel.syncPlayers()
            }
            .onDisappear {
                game.unsubscribeFromGameChannels()
            }
    }
    func createPlayerViews() {
        for gamePlayer in game.gamePlayers {
            if gamePlayer.player.id == game.clientId {
                gamePlayer.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 200)
                localPlayer = PlayerView(gamePlayer: gamePlayer, game: game, localPlayer: true, namespace: animation)
            } else {
                print("creating playerview")
                let playerView: PlayerView
                playerView = PlayerView(gamePlayer: gamePlayer, game: game, localPlayer: false, namespace: animation)
                playerViews.append(playerView)
            }
        }
    }
}

class Card: Identifiable, Equatable, ObservableObject {
    static func == (lhs: Card, rhs: Card) -> Bool {
        // Something
        return true
    }
    let power: Int
    let id = UUID()
    var description: String = ""
    var name: String = ""
    @Published var faceDown: Bool
    init(power: Int, faceDown: Bool) {
        self.power = power
        self.faceDown = faceDown
    }
    init(from card: CardResponse) {
        self.power = card.power
        self.description = card.description
        self.name = card.name
        self.faceDown = true
    }
}
