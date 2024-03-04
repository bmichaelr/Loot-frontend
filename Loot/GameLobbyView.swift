//
//  GameLobbyView.swift
//  Created by Kenna Chase on 2/26/24.
//

import SwiftUI

struct GameLobbyView: View {

    var body: some View {
       
        HStack{
            Spacer()
                
            Text("Game Lobby")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .bold()
    
            Spacer()
       }
        
        VStack{
            Text("Messages: .....")
            //TODO: Add websocket text component to display recieved websocket information 
            
        }.padding()
        
        Spacer()
    }
}

#Preview {
    GameLobbyView()
}
