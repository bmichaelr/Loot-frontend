import SwiftUI

enum ImageEnum: String {
    case loot2 = "loot_2"
    case loot3 = "loot_3"
    case loot5 = "loot_5"
    case loot7 = "loot_7"
    case loot6 = "loot_6"
    func next() -> ImageEnum {
        switch self {
            case .loot2: return .loot3
            case .loot3: return .loot5
            case .loot5: return .loot7
            case .loot7: return .loot6
            case .loot6: return .loot2
        }
    }
}

struct CustomLoadingView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var loadingText: [String] = "LOOT!...".map { String($0) }
    @State private var showLoadingText: Bool = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let imageTimer = Timer.publish(every: 2.0, on: .main, in: .common).autoconnect() // images timer
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @State private var img = ImageEnum.loot2
    @State private var fadeOut = false
    @Binding var showCustomLoadingView: Bool
    var body: some View {
        if isActive {
            GameLobbyView()
        } else {
            ZStack {
                Color.lootBrown.ignoresSafeArea(.all)
                VStack {
                    VStack {
                        Spacer()
                        HStack(alignment: .center) {
                            Image(img.rawValue)
                                .resizable()
                                .frame(width: 225, height: 225)
                                .opacity(fadeOut ? 0 : 1)
                                .animation(.easeInOut(duration: 0.25), value: fadeOut)
                                .scaledToFit()
                                .cornerRadius(7)
                                .padding(5)
                                .background(Color.lootBeige)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .inset(by: 0.50)
                                        .stroke(.black, lineWidth: 2)
                                )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(height: 100)
                                .frame(width: 225)
                                .background(Color.lootBeige)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .inset(by: 0.50)
                                        .stroke(.black, lineWidth: 2)
                                )
                                .padding()
                                .offset(y: -10)
                            Spacer()
                            if showLoadingText {
                                HStack(spacing: 0) {
                                    ForEach(loadingText.indices) { index in
                                        Text(loadingText[index])
                                            .font(Font.custom("Quasimodo", size: 48).weight(.medium))
                                            .foregroundColor(.black)
                                            .bold()
                                            .offset(y: counter == index ? -5 : 0)
                                    }
                                }
                                .transition(AnyTransition.scale.animation(.easeIn))
                            }
                        }
                        .offset(y: 70)
                        Spacer()
                    }
                    .onAppear {
                        showLoadingText.toggle()
                    }
                    .onReceive(timer) { _ in
                        withAnimation(.spring()) {
                            let lastIndex = loadingText.count - 1
                            if counter == lastIndex {
                                counter = 0
                                loops += 1
                                if loops >= 4 { // *** THIS is 4 sec timer adjust down to 1-2 ***
                                    showCustomLoadingView = false
                                }
                            } else {
                                counter += 1
                            }
                        }
                    }
                    .onReceive(imageTimer) { _ in
                        withAnimation {
                            self.fadeOut.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                self.img = self.img.next()
                                self.fadeOut.toggle()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CustomLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        CustomLoadingView(showCustomLoadingView: .constant(true))
    }
}
