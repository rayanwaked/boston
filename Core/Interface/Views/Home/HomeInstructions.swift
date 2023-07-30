//
//  HomeUseView.swift
//  Boston
//
//  Created by Rayan Waked on 2/16/23.
//

import SwiftUI

struct HomeIntructions: View {
    var body: some View {
        VStack {
            Text("Instructions")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Allow 30-seconds for the Siri Shortcut to finish setting up in the background.")
                .fixedSize(horizontal: false,
                           vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
            
            Text("Activate Siri by saying 'Hey Siri', or holding down the power button. When Siri is ready, say or type 'Boston'.")
                .fixedSize(horizontal: false,
                           vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
            
            Text("When Siri says 'What would you like to ask Boston?', you are ready to ask anything!")
                .fixedSize(horizontal: false,
                           vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)
        }
    }
}

struct HomeIntructions_Previews: PreviewProvider {
    static var previews: some View {
        HomeIntructions()
    }
}
