//
//  ChatUserMessage.swift
//  Boston
//
//  Created by Rayan Waked on 3/10/23.
//

import SwiftUI

struct ChatUserMessage: View {
    var userMessage: String
    
    var body: some View {
        VStack(alignment: .trailing) {
            Text(userMessage)
                .padding([.top, .bottom], 15)
                .padding([.leading, .trailing], 20)
                .background(Color.darkOxfordBlue)
                .foregroundColor(.white)
                .cornerRadius(30)
                .textSelection(.enabled)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding([.top, .bottom], 10)
        .padding([.leading, .trailing], 10)
    }
}

struct ChatUserMessage_Previews: PreviewProvider {
    static var previews: some View {
        ChatUserMessage(userMessage: "Hello")
    }
}
