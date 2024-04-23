//
//  TutorialView.swift
//  Loot
//
//  Created by ian on 4/18/24.
//

import SwiftUI

struct TutorialView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var createButtonPressed = false

    var body: some View {
            ScrollView {
                ZStack {
                Color.lootBrown.ignoresSafeArea(.all)
                VStack(alignment: .center) {
                    Text("Tutorial")
                        .font(.custom("Quasimodo", size: 20))
                        .foregroundStyle(Color.lootBeige)
                        .padding([.top, .bottom], 15)
                    Divider()
                        .frame(height: 1)
                        .background(Color.black)
                        .padding([.leading, .trailing], 25)
                    VStack {
                        Text("Introduction:")
                            .font(.custom("Quasimodo", size: 20))
                            .foregroundStyle(Color.lootBrown)
                            .padding([.top, .leading], 15)
                        Divider()
                            .frame(height: 1)
                            .background(Color.black)
                            .padding([.leading, .trailing], 55)
                        HStack {
                            Image("gameboardmockup")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.lootBrown)
                                .padding(.leading, 8)
                            Text("Welcome to the tutorial for Loot! In this game, players compete to be the last one standing by eliminating fellow players or being the last one to hold a card.")
                                .font(.custom("Quasimodo", size: 15))
                                .foregroundStyle(Color.lootBrown)
                                .padding(.leading, 10)
                            Spacer()
                        } // end hstack gameboardmockup and introduction
                    } // end intro vstack
                    .padding([.top, .bottom], 5)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.lootBeige).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 2)
                    )) // rectangle frame around vstack aka topics
                    
                    VStack {
                        Text("Game Setup:")
                            .font(.custom("Quasimodo", size: 20))
                            .foregroundStyle(Color.lootBrown)
                            .padding([.top, .leading], 15)
                        Divider()
                            .frame(height: 1)
                            .background(Color.black)
                            .padding([.leading, .trailing], 55)
                        HStack {
                            Image("gameboardmockup")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.lootBrown)
                                .padding(.leading, 8)
                            VStack(alignment: .center) {
                                Text("1) There are 16 cards faced down in a draw pile. The cards are automatically shuffled at the beginning of each round.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                                Spacer()
                                Text("2) Each player is initially dealt 1 card face down.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 8)
                                Spacer()
                                Text("3) Currently the starting player is the host. When a player wins a round they become the starting player of the following round.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                                Spacer()
                            } // vstack end
                            Spacer()
                        } // end hstack gameboardmockup and introduction
                    } // end intro vstack
                    .padding([.top, .bottom], 5)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.lootBeige).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 2)
                    )) // rectangle frame around vstack aka topics
                    // removed custom create button so you know what to reference
                    Spacer()
                    
                    VStack {
                        Text("Gameplay:")
                            .font(.custom("Quasimodo", size: 20))
                            .foregroundStyle(Color.lootBrown)
                            .padding([.top, .leading], 15)
                        Divider()
                            .frame(height: 1)
                            .background(Color.black)
                            .padding([.leading, .trailing], 55)
                        HStack {
                            Image("gameboardmockup")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.lootBrown)
                                .padding(.leading, 8)
                            VStack(alignment: .center) {
                                Text("1) Draw a card from the pile.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 8)
                                Spacer()
                                Text("2) Choose 1 of the 2 cards in your hand to play.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 8)
                                Spacer()
                                Text("3) Place the card down and apply the effect of the played card.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                                Spacer()
                                Text("4) After, your card stays on the table face up for all to see.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                                Spacer()
                                Text("5) Turns alternate until a final player wins the round.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                                Spacer()
                                Text("6) Once eliminated, you spectate the opponent players.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 8)
                            } // vstack end
                            Spacer()
                        } // end hstack gameboardmockup and introduction
                    } // end intro vstack
                    .padding([.top, .bottom], 5)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.lootBeige).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 2)
                    )) // rectangle frame around vstack aka topics
                    
                    VStack {
                        Text("Card Effects:")
                            .font(.custom("Quasimodo", size: 20))
                            .foregroundStyle(Color.lootBrown)
                            .padding([.top, .leading], 15)
                        Divider()
                            .frame(height: 1)
                            .background(Color.black)
                            .padding([.leading, .trailing], 55)
                        HStack {
                            Image("gameboardmockup")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.lootBrown)
                                .padding(.leading, 8)
                            VStack(alignment: .center) {
                                Text("1) Potted Plant: Guess the type of card another player is holding. If correct, they're out.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 8)
                                Spacer()
                                Text("2) Maul Rat: Compare hands with another player. Lower card is out.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 8)
                                Spacer()
                                Text("3) Duck of Doom: Look at another player's hand. Whichever has the lower value is out of the round.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                                Spacer()
                                Text("4) Wishing Ring: You're immune to card effects until your next turn.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                                Spacer()
                                Text("5) Net Troll: Choose a player to discard their hand and draw a new card.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                                Spacer()
                                Text("6) Dread Gazebo: Trade hands with another player.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                                Spacer()
                                Text("7) Dragon: If you have this card and the Dread Gazebo or Net Troll in your hand, you must discard this card.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                                Spacer()
                                Text("8) Loot!: If played or discarded, round ends.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                            } // vstack end
                            Spacer()
                        } // end hstack gameboardmockup and introduction
                    } // end intro vstack
                    .padding([.top, .bottom], 5)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.lootBeige).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 2)
                    )) // rectangle frame around vstack aka topics
                    
                    VStack {
                        Text("Elimination:")
                            .font(.custom("Quasimodo", size: 20))
                            .foregroundStyle(Color.lootBrown)
                            .padding([.top, .leading], 15)
                        Divider()
                            .frame(height: 1)
                            .background(Color.black)
                            .padding([.leading, .trailing], 55)
                        HStack {
                            Image("gameboardmockup")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.lootBrown)
                                .padding(.leading, 8)
                            VStack(alignment: .center) {
                                Text("1) If you're out, you're out for the round.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                                Text("2) Last player standing wins the round.")
                                    .font(.custom("Quasimodo", size: 12))
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 8)
                            } // vstack end
                        } // end hstack gameboardmockup and introduction
                    } // end intro vstack
                    .padding([.top, .bottom], 5)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.lootBeige).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 2)
                    )) // rectangle frame around vstack aka topics
                    
                    VStack {
                        Text("End of Round:")
                            .font(.custom("Quasimodo", size: 20))
                            .foregroundStyle(Color.lootBrown)
                            .padding([.top, .leading], 15)
                        Divider()
                            .frame(height: 1)
                            .background(Color.black)
                            .padding([.leading, .trailing], 55)
                        HStack {
                            Image("gameboardmockup")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.lootBrown)
                                .padding(.leading, 8)
                            VStack(alignment: .center) {
                                Text("1) Reshuffle all played cards (except Loot!) with remaining draw pile cards for a new round.")
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                            } // vstack end
                        } // end hstack gameboardmockup and introduction
                    } // end intro vstack
                    .padding([.top, .bottom], 5)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.lootBeige).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 2)
                    )) // rectangle frame around vstack aka topics
                    
                    VStack {
                        Text("Winning the Game:")
                            .font(.custom("Quasimodo", size: 20))
                            .foregroundStyle(Color.lootBrown)
                            .padding([.top, .leading], 15)
                        Divider()
                            .frame(height: 1)
                            .background(Color.black)
                            .padding([.leading, .trailing], 55)
                        HStack {
                            Image("gameboardmockup")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.lootBrown)
                                .padding(.leading, 8)
                            VStack(alignment: .center) {
                                Text("1) The first player to win the allotted number of rounds (1-8) wins the game.")
                                    .foregroundStyle(Color.lootBrown)
                                    .padding(.leading, 10)
                            } // vstack end
                        } // end hstack gameboardmockup and introduction
                    } // end intro vstack
                    .padding([.top, .bottom], 5)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.lootBeige).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 2)
                    )) // rectangle frame around vstack aka topics
                    // removed custom create button so you know what to reference
                }
                .padding()
            } // zstack end
                .sheet(isPresented: $createButtonPressed) {
                    TutorialView()
                        .presentationDetents([.medium])
                }
        } // end scroll
    }
}

#Preview {
    TutorialView()
}
