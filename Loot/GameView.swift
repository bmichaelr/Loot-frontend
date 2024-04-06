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
//        game.gamePlayers.append(GamePlayer(from: Player(name: "Josh", id: game.clientId)))
//        game.gamePlayers.append(GamePlayer(from: Player(name: "Ben", id: UUID())))
//        game.gamePlayers.first!.playerHand.cards.append(Card(from: CardResponse(power: 1, name: "potted plant", description: "")))
//        game.gamePlayers.first!.playerHand.cards.append(Card(from: CardResponse(power: 2, name: "potted plant", description: "")))
//        game.gamePlayers.first!.playerHand.cards.append(Card(from: CardResponse(power: 3, name: "potted plant", description: "")))
//        game.gamePlayers.first!.playerHand.cards.append(Card(from: CardResponse(power: 4, name: "potted plant", description: "")))
//        game.gamePlayers.first!.playerHand.cards.append(Card(from: CardResponse(power: 5, name: "potted plant", description: "")))
//        game.gamePlayers.first!.playerHand.cards.append(Card(from: CardResponse(power: 6, name: "potted plant", description: "")))
//        game.gamePlayers.first!.playerHand.cards.append(Card(from: CardResponse(power: 7, name: "potted plant", description: "")))
//        game.gamePlayers.first!.playerHand.cards.append(Card(from: CardResponse(power: 8, name: "potted plant", description: "")))
//        game.gamePlayers.first!.isCurrentTurn = true
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

class Card: Identifiable, Equatable, ObservableObject, Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        // Something
        return true
    }
    enum CardType {
        case guessing
        case normal
        case targeted
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    let type: CardType?
    let power: Int
    let id = UUID()
    var description: String = ""
    var name: String = ""
    @Published var faceDown: Bool
    init(power: Int, faceDown: Bool) {
        self.power = power
        self.faceDown = faceDown
        self.type = .normal
    }
    init(from card: CardResponse) {
        self.power = card.power
        self.description = card.description
        self.name = card.name
        self.faceDown = true
        switch power {
        case 1:
            self.type = .guessing
        case 2, 3, 5, 6:
            self.type = .targeted
        case 4, 7, 8:
            self.type = .normal
        default:
            self.type = .normal
        }
    }
}
