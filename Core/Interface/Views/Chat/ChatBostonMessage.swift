//
//  ChatBostonMessage.swift
//  Boston
//
//  Created by Rayan Waked on 3/10/23.
//

import SwiftUI

struct ChatBostonMessage: View {
    var bostonMessage: String
    
    var body: some View {
        HStack {
            Text(bostonMessage)
                .padding([.top, .bottom], 15)
                .padding([.leading, .trailing], 20)
                .background(Color.dogWood)
                .foregroundColor(.darkOxfordBlue)
                .cornerRadius(30)
                .textSelection(.enabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.top, .bottom], 10)
        .padding([.leading, .trailing], 10)
    }
}

struct ChatBostonMessage_Previews: PreviewProvider {
    static var previews: some View {
        ChatBostonMessage(bostonMessage: "Hi")
    }
}
