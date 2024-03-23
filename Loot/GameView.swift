import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var centerCards: [CenterCard] = []
    @State var playerViews: [PlayerView] = []
    @State var numberOfCards: Int = 0
    @StateObject var game: Game
    init() {
        var gamePlayers = [GamePlayer]()
        for index in 0..<4 {
            gamePlayers.append(GamePlayer(name: "Player\(index)", cards: []))
        }
        self._game = StateObject(wrappedValue: Game(players: gamePlayers))
    }
    let centerPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(playerViews.indices, id: \.self) { index in
                    playerViews[index]
                }
                ForEach(0..<numberOfCards, id: \.self) { index in
                    CenterCard(number: 0, player: game.players[index])
                }
                Button(action: {
                    print(numberOfCards)
                    if numberOfCards <= 3 {
                        createCenterCards()
                    } else {
                        numberOfCards = 0
                        createCenterCards()
                    }
                }, label: {
                    Text("Deal!")
                })
            }
            .onAppear {
                createPlayerViews(geometry: geometry) // Create PlayerView instances when the view appears
                createCenterCards()
            }
        }
    }
    func createCenterCards() {
        for index in game.players.indices {
            // Asynchronously update the numberOfCards variable after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                // Update the state of numberOfCards
                numberOfCards += 1
            }
        }
    }
    func createPlayerViews(geometry: GeometryProxy) {
        for playerIndex in 0..<game.players.count {
            let playerView = PlayerView(
                player: game.players[playerIndex]
            )
            // game.players[playerIndex].id = viewModel.lobbyData.players[index].id
            game.players[playerIndex].index = playerIndex
            game.players[playerIndex].rotation = angleForPlayer(
                playerIndex: playerIndex
            )
            game.players[playerIndex].position = playerPosition(
                playerIndex: playerIndex)
            playerViews.append(playerView) // Add PlayerView instance to the array
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
        // let width = geometry.size.width
        // let height = geometry.size.height
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
                    case 1: return CGPoint(x: 50, y: center.y) // Left
                    case 2: return CGPoint(x: center.x, y: 50) // Top
                    default: return CGPoint(x: width - 50, y: center.y) // Right
                    }
                default:
                    return .zero
                }
            }
        }
        return .zero
    }
    struct PlayerView: View {
        @ObservedObject var player: GamePlayer
        var body: some View {
            ZStack {
                // Main player's individual card
                 if player.index == 0 {
                     VStack {
                         Text(player.name)
                         HStack(spacing: 10) {
                             CardStackView(player: player, type: "hand").onTapGesture {
                                 player.addToPlayed(Card(number: 10, flipped: false))
                             }
                             CardStackView(player: player, type: "played")
                         }
                     }.position(player.position)
                 } else {
                     VStack {
                         Text(player.name)
                         HStack(spacing: 10) {
                             CardStackView(player: player, type: "hand")
                         }
                         .rotationEffect(player.rotation)
                     }.position(player.position)
                 }
            }
        }
    }
    struct CardStackView: View {
        @ObservedObject var player: GamePlayer
        let type: String
        var body: some View {
            HStack(spacing: -30) {
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
