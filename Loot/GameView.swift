import SwiftUI

struct GameView: View {
    let numberOfPlayers: Int = 2
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<numberOfPlayers) { playerIndex in
                    PlayerView(playerIndex: playerIndex, playerCount: numberOfPlayers, position: playerPosition(playerIndex: playerIndex, totalPlayers: numberOfPlayers, geometry: geometry))
                }
                CenterCardView(position: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
            }
        }
    }
    func playerPosition(playerIndex: Int, totalPlayers: Int, geometry: GeometryProxy) -> CGPoint {
        let width = geometry.size.width
        let height = geometry.size.height
        let center = CGPoint(x: width / 2, y: height / 2)
        let spacing: CGFloat = 20
        switch totalPlayers {
        case 2:
            return playerIndex == 0 ? CGPoint(x: center.x, y: height - 50) : CGPoint(x: center.x, y: 50)
        case 3:
            return playerIndex == 0 ? CGPoint(x: center.x, y: height - 50) : CGPoint(x: playerIndex == 1 ? 50 : width - 50, y: center.y)
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

struct PlayerView: View {
    @State private var numberOfCards: Int = 3
    let playerIndex: Int
    let playerCount: Int
    let position: CGPoint
    var body: some View {
        ZStack {
            // Main player's individual card
            if playerIndex == 0 {
                var playerCards = CardStackView(cards: numberOfCards) // Main player's card stack
                HStack(spacing: 10) {
                    CardView(number: Int.random(in: 1..<8)).onTapGesture {
                        numberOfCards+=1
                    } // Main player's card
                    playerCards
                }
                .position(x: position.x, y: position.y + 30)
                
            } else {
                CardStackView(cards: 3) // Other players' card stack
                //let result = [2, 3, 4].contains(number) ? number : defaultValue
                    .rotationEffect(angleForPlayer(playerIndex: playerIndex, playerCount: playerCount))
                    .position(position)
            }
        }
    }
    func angleForPlayer(playerIndex: Int, playerCount: Int) -> Angle {
        print(playerIndex)
        switch playerCount {
        case 2: return .degrees(Double(playerIndex * 180))
        case 3: return .degrees(90 * (pow(2, Double(playerIndex)) - 1))
        case 4: return .degrees(Double(playerIndex * 90))
        default: return .degrees(0) // player
        }
    }
}

struct CardView: View {
    var number: Int
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 50, height: 75)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
            
            Text("\(number)")
                .font(.system(size: 14))
                .foregroundColor(.black)
                .padding(4)
        }
    }
}

struct CardStackView: View {
    var cards: Int
    var body: some View {
        HStack(spacing: -30) {
            ForEach(0..<cards, id: \.self) { index in
                CardView(number: Int.random(in: 1..<8))
            }
        }
    }
}

struct CenterCardView: View {
    let position: CGPoint
    var body: some View {
        CardView(number: Int.random(in: 1..<8))
            .position(position)
    }
}
