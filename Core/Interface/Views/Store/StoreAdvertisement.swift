//
//  StoreAdvertisement.swift
//  Boston
//
//  Created by Rayan Waked on 2/19/23.
//

import SwiftUI

struct StoreAdvertisement: View {
    var advertisement: String = "Upgrade Boston to get more powerful, personal, and detailed responses."
    
    var body: some View {
        HStack {
            Text("Upgrade Boston to get more powerful, personal, and detailed responses.")
                .fixedSize(horizontal: false,
                           vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.bold)
            
            
            
            NavigationLink(destination: StoreView()) {
                ZStack {
                    Circle()
                        .frame(width: 60, height: 60)
                    Image(systemName: "arrow.right")
                        .foregroundColor(.dogWood)
                        .fontWeight(.bold)
                }
                .padding(.leading, 20)
            }
        }
    }
}

struct StoreAdvertisement_Previews: PreviewProvider {
    static var previews: some View {
        StoreAdvertisement()
    }
}
