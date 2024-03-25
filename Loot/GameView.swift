import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var centerCards: [CenterCard] = []
    @State var playerViews: [PlayerView] = []
    @State var numberOfCards: Int = 0
    @StateObject var game: Game
    let centerPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    init() {
        var gamePlayers = [GamePlayer]()
        self._game = StateObject(wrappedValue: Game(players: gamePlayers))
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(playerViews.indices, id: \.self) { index in
                    playerViews[index]
                }
                ForEach(0..<numberOfCards, id: \.self) { index in
                    CenterCard(number: 0, player: game.players[index])
                }
            }
            .onAppear {
                createPlayerViews(geometry: geometry) // Create PlayerView instances when the view appears
                createCenterCards()
            }
        }
    }
    func createCenterCards() {
        for index in game.players.indices {
            print(game.players[index].position)
            // Asynchronously update the numberOfCards variable after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                // Update the state of numberOfCards
                numberOfCards += 1
            }
        }
    }
    func createPlayerViews(geometry: GeometryProxy) {
        // Find the index of the current player (if any)
        if let currentPlayerIndex = viewModel.lobbyData.players.firstIndex(where: { $0.id == viewModel.clientUUID }) {
            let currentPlayer = viewModel.lobbyData.players[currentPlayerIndex]
            let currentPlayerInGame = GamePlayer(name: currentPlayer.name, cards: [])
            game.players.insert(currentPlayerInGame, at: 0)
        }
        // Append other players to game.players
        for playerIndex in 0..<viewModel.lobbyData.players.count {
            let playerId = viewModel.lobbyData.players[playerIndex].id
            if playerId != viewModel.clientUUID {
                let playerName = viewModel.lobbyData.players[playerIndex].name
                let playerInGame = GamePlayer(name: playerName, cards: [])
                game.players.append(playerInGame)
            }
        }
        // Update player properties
        for playerIndex in 0..<game.players.count {
            let player = game.players[playerIndex]
            player.index = playerIndex
            player.rotation = angleForPlayer(playerIndex: playerIndex)
            player.position = playerPosition(playerIndex: playerIndex)
            let playerView = PlayerView(player: player, game: game)
            playerViews.append(playerView)
        }
    }
    func angleForPlayer(playerIndex: Int) -> Angle {
        switch game.players.count {
        case 2: return .degrees(Double(playerIndex * 180))
        case 3: return .degrees(90 * (pow(2, Double(playerIndex)) - 1))
        case 4: return .degrees(Double(playerIndex * 90))
        default: return .degrees(0) // player
        }
    }
    func playerPosition(playerIndex: Int) -> CGPoint {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                let safeAreaInsets = window.safeAreaInsets
                let width = UIScreen.main.bounds.width - safeAreaInsets.left - safeAreaInsets.right
                let height = UIScreen.main.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
                let center = CGPoint(x: width / 2, y: height / 2)
                switch game.players.count {
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
                    case 1: return CGPoint(x: 60, y: center.y) // Left
                    case 2: return CGPoint(x: center.x, y: 50) // Top
                    default: return CGPoint(x: width - 60, y: center.y) // Right
                    }
                default:
                    return CGPoint(x: center.x, y: height - 50)
                }
            }
        }
        return .zero
    }
    struct PlayerView: View {
        @ObservedObject var player: GamePlayer
        @ObservedObject var game: Game
        var body: some View {
            ZStack {
                if player.index == 0 {
                    HStack {
                        VStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 30, height: 30)
                            Text(player.name).font(.caption)
                            HStack(spacing: 10) {
                                CardStackView(player: player, type: "hand")
                                    .onTapGesture {
                                        game.addToPlayedCards(card: Card(number: 8, flipped: false))
                                    }
                            }
                        }.position(player.position)
                    }
                } else if player.position.x < UIScreen.main.bounds.width / 2 { // Left Side
                    ZStack {
                        HStack(spacing: 10) {
                            CardStackView(player: player, type: "hand")
                        }.rotationEffect(player.rotation)
                        VStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 30, height: 30)
                            Text(player.name).font(.caption)
                        }.offset(CGSize(width: 65, height: 0))
                    }.position(player.position)
                } else if player.position.x > UIScreen.main.bounds.width / 2 { // Right Side
                    ZStack {
                        VStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 30, height: 30)
                            Text(player.name).font(.caption)
                        }.offset(CGSize(width: -65, height: 0))
                        HStack(spacing: 10) {
                            CardStackView(player: player, type: "hand")
                        }.rotationEffect(player.rotation)
                    }.position(player.position)
                } else {
                    VStack {
                        HStack(spacing: 10) {
                            CardStackView(player: player, type: "hand")
                        }.rotationEffect(player.rotation)
                        Circle()
                            .fill(.white)
                            .frame(width: 30, height: 30)
                        Text(player.name).font(.caption)
                    }.position(player.position)
                }
            }
        }
    }
    struct CardStackView: View {
        @ObservedObject var player: GamePlayer
        let type: String
        var body: some View {
            HStack {
                if type == "hand" {
                    ForEach(player.hand.indices, id: \.self) { index in
                        CardView(card: player.hand[index])
                    }
                } else {
                    ForEach(player.played.indices, id: \.self) { index in
                        CardView(card: player.played[index])
                    }
                }
            }
        }
    }
    struct PlayedCards: View {
        @ObservedObject var game: Game
        var body: some View {
            HStack(spacing: -30) {
                ForEach(game.playedCards.indices, id: \.self) { index in
                    CardView(card: game.playedCards[index])
                }
            }
        }
    }
    struct CenterCard: View {
        var number: Int
        let player: GamePlayer
        @State var position: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
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
                .rotationEffect(player.rotation)
                .position(position)
                .onAppear {
                    withAnimation {
                        move(to: player.position)
                    } completion: {
                        // Add card to player
                        if player.index == 0 {
                            player.addToHand(Card(number: number, flipped: false))
                        } else {
                            player.addToHand(Card(number: number, flipped: true))
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
    @Published var playedCards: [Card] = []
    init(players: [GamePlayer]) {
        self.players = players
    }
    func addCard(toPlayer playerIndex: Int, card: Card) {
        guard playerIndex >= 0 && playerIndex < players.count else { return }
        players[playerIndex].addCard(card)
    }
    func addToHand(toPlayer playerIndex: Int, card: Card) {
        guard playerIndex >= 0 && playerIndex < players.count else { return }
        players[playerIndex].addToHand(card)
    }
    func addToPlayed(toPlayer playerIndex: Int, card: Card) {
        guard playerIndex >= 0 && playerIndex < players.count else { return }
        players[playerIndex].addToPlayed(card)
    }
    func addToPlayedCards(card: Card) {
        playedCards.append(card)
    }
}

class GamePlayer: ObservableObject {
    @Published var cards: [Card] = []
    @Published var hand: [Card] = []
    @Published var played: [Card] = []
    let name: String
    var position: CGPoint = .zero
    var index: Int = 0
    var rotation: Angle = .zero
    var id: UUID = UUID()
    init(name: String, cards: [Card]) {
        self.name = name
        self.cards = cards
    }
    func addCard(_ card: Card) {
        cards.append(card)
    }
    func addToHand(_ card: Card) {
        hand.append(card)
    }
    func addToPlayed(_ card: Card) {
        played.append(card)
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
