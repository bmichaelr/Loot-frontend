import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var players: [Player] = [
        Player(name: "player1", id: UUID()),
        Player(name: "player2", id: UUID())
    ]
    @State var centerCards: [CenterCard] = []
    @State var playerViews: [PlayerView] = []
    @StateObject var game: Game
    init() {
        let gamePlayers = [
            GamePlayer(name: "Player 1", cards: []),
            GamePlayer(name: "Player 2", cards: []),
            GamePlayer(name: "Player 3", cards: []),
            GamePlayer(name: "Player 4", cards: [])
        ]
        self._game = StateObject(wrappedValue: Game(players: gamePlayers))
    }
    let centerPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(playerViews.indices, id: \.self) { index in
                    playerViews[index]
                    centerCards[index]
                        .position(centerPosition)
                }
            }
            .onAppear {
                createPlayerViews(geometry: geometry) // Create PlayerView instances when the view appears
                createCenterCards()
            }
        }
    }
    func createCenterCards() {
        for playerIndex in 0..<game.players.count {
            let centerCard = CenterCard(
                number: playerIndex,
                player: game.players[playerIndex],
                position: centerPosition,
                rotation: game.players[playerIndex].rotation
            )
            print("creating center card")
            centerCards.append(centerCard)
        }
    }
    func createPlayerViews(geometry: GeometryProxy) {
        for playerIndex in 0..<game.players.count {
            let playerView = PlayerView(
                player: game.players[playerIndex]
            )
            game.players[playerIndex].index = playerIndex
            game.players[playerIndex].rotation = angleForPlayer(
                playerIndex: playerIndex,
                playerCount: game.players.count
            )
            game.players[playerIndex].position = playerPosition(
                playerIndex: playerIndex,
                totalPlayers: game.players.count,
                geometry: geometry)
            playerViews.append(playerView) // Add PlayerView instance to the array
        }
    }
    func angleForPlayer(playerIndex: Int, playerCount: Int) -> Angle {
        switch playerCount {
        case 2: return .degrees(Double(playerIndex * 180))
        case 3: return .degrees(90 * (pow(2, Double(playerIndex)) - 1))
        case 4: return .degrees(Double(playerIndex * 90))
        default: return .degrees(0) // player
        }
    }
    func playerPosition(playerIndex: Int, totalPlayers: Int, geometry: GeometryProxy) -> CGPoint {
        let width = geometry.size.width
        let height = geometry.size.height
        let center = CGPoint(x: width / 2, y: height / 2)
        // let spacing: CGFloat = 20
        switch totalPlayers {
        case 2:
            return playerIndex == 0 ? CGPoint(x: center.x, y: height - 50) : CGPoint(x: center.x, y: 50)
        case 3:
            return playerIndex == 0 ?
            CGPoint(
                x: center.x,
                y: height - 50
            )
            : CGPoint(
                x: playerIndex == 1 ? 50 : width - 50,
                y: center.y
            )
        case 4:
            switch playerIndex {
            case 0: return CGPoint(x: center.x, y: height - 50) // Bottom
            case 1: return CGPoint(x: 50, y: center.y) // Left
            case 2: return CGPoint(x: center.x, y: 50) // Top
            default: return CGPoint(x: width - 50, y: center.y) // Right
            }
        default:
            return .zero
        }
    }
    struct PlayerView: View {
        @ObservedObject var player: GamePlayer
        var body: some View {
            ZStack {
                // Main player's individual card
                if player.index == 0 {
                    // let playerCards = CardStackView(cards: numberOfCards) // Main player's card stack
                    // playerHand
                    VStack {
                        Text(player.name)
                        HStack(spacing: 10) {
                            CardStackView(player: player)
                            // playerCards
                        }
                    }.position(player.position)
                } else {
                    VStack {
                        Text(player.name)
                        HStack {
                            CardStackView(player: player)
                        }
                        .rotationEffect(player.rotation)
                    }.position(player.position)
                }
            }
        }
    }
    struct CardStackView: View {
        @ObservedObject var player: GamePlayer
        var body: some View {
            HStack {
                ForEach(player.cards.indices, id: \.self) { index in
                    CardView(card: player.cards[index])
                }
            }
        }
    }
    struct CenterCard: View {
        var number: Int
        let player: GamePlayer
        @State var position: CGPoint
        @State var rotation: Angle
        @State private var isHidden = false // Control visibility
        var body: some View {
            if !isHidden { // Only show the view if it's not hidden
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red)
                        .frame(width: 50, height: 75)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                    Text("Loot!")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .padding(4)
                }
                .rotationEffect(rotation)
                .position(position)
                .onAppear {
                    withAnimation {
                        move(to: player.position)
                    } completion: {
                        // Add card to player
                        if player.index == 0 {
                            player.addCard(Card(number: number, flipped: false))
                        } else {
                            player.addCard(Card(number: number, flipped: true))
                        }
                        // Hide the view
                        isHidden = true
                    }
                }
            }
        }
        func move(to new: CGPoint) {
            position = new
        }
    }

}

class Game: ObservableObject {
    @Published var players: [GamePlayer]
    init(players: [GamePlayer]) {
        self.players = players
    }
    func addCard(toPlayer playerIndex: Int, card: Card) {
        guard playerIndex >= 0 && playerIndex < players.count else { return }
        players[playerIndex].addCard(card)
    }
}

class GamePlayer: ObservableObject {
    @Published var cards: [Card] = []
    let name: String
    var position: CGPoint = .zero
    var index: Int = 0
    var rotation: Angle = .zero
    init(name: String, cards: [Card]) {
        self.name = name
        self.cards = cards
    }
    func addCard(_ card: Card) {
        cards.append(card)
    }
}

class Card: ObservableObject {
    @Published var number: Int
    @Published var flipped: Bool
    // Add more properties as needed
    init(number: Int, flipped: Bool) {
        self.number = number
        self.flipped = flipped
    }
}

struct CardView: View {
    var number: Int
    var flipped: Bool
    init(card: Card) {
        self.number = card.number
        self.flipped = card.flipped
    }
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(flipped ? Color.red : Color.white) // Change color based on flipped status
                .frame(width: 50, height: 75)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
            Text(flipped ? "Loot!" : "\(number)")
                .font(.system(size: 14))
                .foregroundColor(.black)
                .padding(4)
        }
    }
}
