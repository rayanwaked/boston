//
//  ChatNavigationButton.swift
//  Boston
//
//  Created by Rayan Waked on 3/10/23.
//

import SwiftUI

struct ChatNavigationButton<Destination: View>: View {
    let destination: Destination
    let icon: Image

    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.darkOxfordBlue)
                icon
                    .foregroundColor(.dogWood)
                    .fontWeight(.bold)
            }
        }
    }
}


struct ChatNavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        ChatNavigationButton(destination: StoreView(), icon: Image(systemName: "star.fill"))
    }
}
