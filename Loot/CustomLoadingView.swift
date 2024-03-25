//
//  CustomLoadingView.swift
//  CustomLoadingView
//
//  Created by ian on 3/12/24.
//

import SwiftUI

struct CustomLoadingView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var loadingLoot: [String] = "LOOT!...".map { String($0) }
    @State private var showLoadingLoot: Bool = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showCustomLoadingView: Bool
    var body: some View {
        if isActive {
            GameLobbyView()
        } else {
            VStack {
                Text("Loading Content Please Wait!")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.init(white: 1.00))
                    .bold()
                    .padding()
                    .frame(width: 500)
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .padding()
                Spacer(minLength: 0)
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Image("ProgressView")
                            .font(.system(size: 80))
                            .cornerRadius(7)
                            .padding(5)
                            .background(Color.yellow)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .frame(width: 100, height: 100)
                    }
                    ZStack {
                        if showLoadingLoot {
                            HStack(spacing: 0) {
                                ForEach(loadingLoot.indices) { index in
                                        Text(loadingLoot[index])
                                        .font(.title)
                                            .fontWeight(.heavy)
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
                    showLoadingLoot.toggle()
                }
                .onReceive(timer, perform: { _ in
                    withAnimation(.spring()) {
                        let lastIndex = loadingLoot.count - 1
                        if counter == lastIndex {
                            counter = 0
                            loops += 1
                            if loops >= 10 {
                                showCustomLoadingView = false
                            }
                        } else {
                            counter += 1
                        }
        
                    }
                })
            }
        }
        
    }
}

struct CustomLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        CustomLoadingView(showCustomLoadingView: .constant(true))
    }
}
