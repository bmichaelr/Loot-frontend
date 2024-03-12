import SwiftUI

struct GameView: View {
    let numberOfPlayers: Int = 4
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<numberOfPlayers) { playerIndex in
                    PlayerView(playerIndex: playerIndex, position: playerPosition(playerIndex: playerIndex, totalPlayers: numberOfPlayers, geometry: geometry))
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
            case 0: return CGPoint(x: center.x, y: height - 50)
            case 1: return CGPoint(x: 50, y: center.y)
            case 2: return CGPoint(x: center.x, y: 50)
            default: return CGPoint(x: width - 50, y: center.y)
            }
        default:
            return .zero
        }
    }
}

struct PlayerView: View {
    let playerIndex: Int
    let position: CGPoint
    
    var body: some View {
        ZStack {
            if playerIndex == 0 {
                CardView()
                    .position(x: position.x, y: position.y + 30)
            } else {
                CardStackView()
                    .rotationEffect(angleForPlayer(playerIndex: playerIndex))
                    .position(position)
            }
        }
    }
    
    func angleForPlayer(playerIndex: Int) -> Angle {
        switch playerIndex {
        case 1: return .degrees(-90)
        case 2: return .degrees(180)
        case 3: return .degrees(90)
        default: return .degrees(0)
        }
    }
}

struct CardView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .frame(width: 50, height: 75)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
    }
}

struct CardStackView: View {
    var body: some View {
        HStack(spacing: -30) {
            ForEach(0..<3) { _ in
                CardView()
            }
        }
    }
}

struct CenterCardView: View {
    let position: CGPoint
    
    var body: some View {
        CardView()
            .position(position)
    }
}
