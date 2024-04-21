//
//  ImageOptionsView.swift
//  Loot
//
//  Created by Kenna Chase on 4/15/24.
//

import SwiftUI

struct ImageOptionsView: View {
    @Binding var imageNumber: Int
    let maxLootImages: Int = 8
    let imageName: String = "loot_"
   // var imageNumber: Int = 1

    var body: some View {
        ZStack {
            Color.lootBrown.ignoresSafeArea(.all)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(1...8, id: \.self) { num in

                            Image(imageName + String(num))
                                .onTapGesture {
                                    imageNumber = num
                                }
                        }
                    }
            }

        }
    }
}

#Preview {
    ImageOptionsView(imageNumber: Binding.constant(1))
}
