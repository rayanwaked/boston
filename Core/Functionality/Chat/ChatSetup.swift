//
//  ChatSetup.swift
//  Boston
//
//  Created by Rayan Waked on 3/13/23.
//

import SwiftUI
import CoreData

struct ChatSetup: View {    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: ConversationUser.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ConversationUser.userTime, ascending: false)])
    var conversationsUser: FetchedResults<ConversationUser>
    
    @FetchRequest(entity: ConversationBoston.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ConversationBoston.bostonTime, ascending: false)])
    var conversationsBoston: FetchedResults<ConversationBoston>
    
    //MARK: Create the chat view
    func setupChat() -> some View {
        var messages: [AnyView] = []

        // Initialize indices to keep track of the current message in each conversation.
        var userIndex = 0, bostonIndex = 0

        // Loop until all messages from both conversations have been processed.
        while userIndex < conversationsUser.count || bostonIndex < conversationsBoston.count {
            // Get the current message from each conversation. If there are no more messages in a conversation, the respective variable will be nil.
            let userMessage = userIndex < conversationsUser.count ? conversationsUser[userIndex] : nil
            let bostonMessage = bostonIndex < conversationsBoston.count ? conversationsBoston[bostonIndex] : nil

            // If both messages exist, compare their times.
            if let userTime = userMessage?.userTime, let bostonTime = bostonMessage?.bostonTime {
                // If the user message is newer, add it to the messages array and increment the user index.
                if userTime > bostonTime {
                    messages.insert(ChatUserMessage(userMessage: userMessage?.userInput ?? "").eraseToAnyView(), at: 0)
                    userIndex += 1
                }
                // If the Boston message is newer or the times are equal, add it to the messages array and increment the Boston index.
                else {
                    messages.insert(ChatBostonMessage(bostonMessage: bostonMessage?.bostonOutput ?? "").eraseToAnyView(), at: 0)
                    bostonIndex += 1
                }
            }
            // If only the user message exists, add it to the messages array and increment the user index.
            else if userMessage != nil {
                messages.insert(ChatUserMessage(userMessage: userMessage?.userInput ?? "").eraseToAnyView(), at: 0)
                userIndex += 1
            }
            // If only the Boston message exists, add it to the messages array and increment the Boston index.
            else if bostonMessage != nil {
                messages.insert(ChatBostonMessage(bostonMessage: bostonMessage?.bostonOutput ?? "").eraseToAnyView(), at: 0)
                bostonIndex += 1
            }
        }


        return VStack {
            ScrollViewReader { proxy in
                VStack {
                    ForEach(messages.indices, id: \.self) { i in
                        messages[i]
                    }
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(messages.count - 1, anchor: .top)
                    }
                }
                .onAppear {
                    withAnimation {
                        proxy.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    var body: some View {
        setupChat()
    }
}
