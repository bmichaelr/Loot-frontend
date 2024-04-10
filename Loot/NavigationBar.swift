import SwiftUI

struct NavigationBar: View {
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack {
                    HStack(spacing: 0) {
                        Button(action: {
                            viewModel.leaveGame(viewModel.lobbyData.roomKey) // going to need to makee
                        }) {
                            Text("Leave")
                                .font(.custom("Quasimodo", size: 14))
                                .foregroundStyle(Color.lootBeige)
                        }
                        .padding(.leading, 10)
                        Spacer()
                        Image("lootpile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60, alignment: .center)
                        Spacer()
                        Button(action: {}, label: {
                            Image("navquestion")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25, alignment: .trailing) // need to implement go2 help action
                        })
                        .padding(.trailing, 10)
                    }
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity)
                    .background(Color.lootBrown)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.black)
                        .edgesIgnoringSafeArea(.all)
                        .padding(.bottom, -1)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.50), radius: 4, y: 4)
                        .padding(.vertical, -5)
                } // end vstack
            } // end zstack
        }
        .onAppear(perform: self.viewModel.subscribeToLobbyChannels)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackground()
    }
}

#Preview {
    NavigationBar()
}
