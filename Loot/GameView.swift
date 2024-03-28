import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State var animatedCards: [AnimatedCard] = []
    @State var playerViews: [PlayerView] = []
    @State var numberOfAnimatedCards: Int = 0
    @StateObject var game: GameModel
    let centerPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    init() {
        let gamePlayers = [GamePlayer]()
        self._game = StateObject(wrappedValue: GameModel(players: gamePlayers))
    }
    var body: some View {
        ZStack {
            CardView(card: Card(number: 0, faceDown: true))
                .position(CGPoint(x: UIScreen.main.bounds.width - 50, y: 0))
                .onTapGesture {
                    animateDealingCards()
                }
            ForEach(0..<numberOfAnimatedCards, id: \.self) { index in
                AnimatedCard(number: index + 1, player: game.players[index])
            }
            ForEach(playerViews.indices, id: \.self) { index in
                playerViews[index]
            }
        }.background(Image("woodlong"))
        .onAppear {
            createPlayerViews()
            animateDealingCards()
        }
    }
    func animateDealingCards() {
        for index in game.players.indices {
            print(game.players[index].position)
            // Asynchronously update the numberOfCards variable after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                // Update the state of numberOfCards
                numberOfAnimatedCards += 1
            }
        }
        numberOfAnimatedCards = 0
    }
    func createPlayerViews() {
        // Find the index of the current player (if any)
        viewModel.lobbyData.players.append(Player(name: "ben", id: UUID()))
        viewModel.lobbyData.players.append(Player(name: "ian", id: UUID()))
        viewModel.lobbyData.players.append(Player(name: "kenna", id: UUID()))
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
        var yOffset = -50
        // Update player properties
        for playerIndex in 0..<game.players.count {
            let player = game.players[playerIndex]
            player.index = playerIndex
            player.position.x = UIScreen.main.bounds.width / 2
            player.position.y = CGFloat(yOffset)
            yOffset += 200
            if playerIndex == 0 {
                player.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 100)
            }
            let playerView = PlayerView(player: player, game: game)
            playerViews.append(playerView)
        }
    }
    struct PlayerView: View {
        @ObservedObject var player: GamePlayer
        @ObservedObject var game: GameModel
        var body: some View {
            ZStack {
                if player.index == 0 {
                    HStack {
                        VStack {
                            Text(player.name).font(.caption)
                            HStack(spacing: 10) {
                                CardStackView(player: player, type: "hand")
                            }.scaleEffect(CGSize(width: 1.5, height: 1.5))
                        }
                    }
                } else {
                    HStack {
                        VStack(spacing: 20) {
                            Circle()
                                .fill(.white)
                                .frame(width: 30, height: 30)
                            Text(player.name).font(.caption)
                        } .frame(alignment: .leading)
                        HStack(spacing: 10) {
                            CardStackView(player: player, type: "hand")
                        }
                    }
                }
            }.position(player.position)
        }
    }
}
struct CardStackView: View {
    @ObservedObject var player: GamePlayer
    let type: String
    var body: some View {
        HStack(spacing: -70) {
            if type == "hand" {
                ForEach(player.hand.indices, id: \.self) { index in
                    if player.index == 0 {
                        CardView(card: player.hand[index]).rotationEffect(Angle(degrees: Double((15 * index + 1))))
                    } else { CardView(card: player.hand[index]) }
                }
            } else {
                ForEach(player.playedCards.indices, id: \.self) { index in
                    CardView(card: player.playedCards[index])
                }.border(.white)
            }
        }
    }
}
struct AnimatedCard: View {
    var number: Int
    let player: GamePlayer
    @State var position: CGPoint = CGPoint(x: UIScreen.main.bounds.width - 50, y: 0)
    @State private var isHidden = false // Control visibility
    var body: some View {
        if !isHidden { // Only show the view if it's not hidden
            CardView(card: Card(number: number, faceDown: true))
            .position(position)
            .onAppear {
                withAnimation {
                    move(to: player.position)
                } completion: {
                    // Add card to player
                    if player.index == 0 {
                        player.addToHand(Card(number: number, faceDown: false))
                    } else {
                        player.addToHand(Card(number: number, faceDown: true))
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

class GameModel: ObservableObject {
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
    @Published var playedCards: [Card] = []
    let name: String
    var position: CGPoint = .zero
    var index: Int = 0
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
        playedCards.append(card)
    }
}

class Card: ObservableObject {
    @Published var number: Int
    @Published var faceDown: Bool
    // Add more properties as needed
    init(number: Int, faceDown: Bool) {
        self.number = number
        self.faceDown = faceDown
    }
}

struct CardView: View {
    var number: Int
    var faceDown: Bool
    let width: CGFloat = 100
    let scale: CGFloat = 2.0 / 3.0
    init(card: Card) {
        self.number = card.number
        self.faceDown = card.faceDown
    }
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(faceDown ? Color.lootBrown : Color.lootBeige) // Change color based on flipped status
                .frame(width: width, height: width * scale + width)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.lootBrown, lineWidth: 8))
            Image(faceDown ? "dragon" : "loot_\(number)")
                .frame(width: width, height: width * scale + width)
                .scaleEffect(0.2 * scale + 0.2)
            Text(faceDown ? "Loot!" : "\(number)")
                .font(.custom("Quasimodo", size: 14 * scale + 14))
                .foregroundColor(faceDown ? Color.lootBeige : .black)
                .frame(alignment: .leading)
                .padding(faceDown ? 6 * scale + 6 : 7 * scale + 7)
        }
    }
}

#Preview {
    CardView(card: Card(number: 1, faceDown: false))
}
