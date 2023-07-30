//
//  ChatHandler.swift
//  Boston
//
//  Created by Rayan Waked on 7/29/23.
//

import OpenAI
import StoreKit
import CoreData
import SwiftUI

class ChatFunctionality {
    let openAI = OpenAI(apiToken: "SK-YOUR-API-KEY")
    
    //MARK: Set Model Type Based On Subscription
    func setModelType() -> Model {
        // Async: Pull data from UserDefaults, update it, update variables
        Task {
            var subscriptionManager = SubscriptionManager(store: StoreManager.shared.store)
            let groupUserDefaults = UserDefaults(suiteName: defaultGroup)
            
            await subscriptionManager.updateSubscriptionStatus()
            print(subscriptionManager.currentSubscription?.displayName as Any)
            
            groupUserDefaults?.set((subscriptionManager.currentSubscription?.displayName ?? "None") as String, forKey: "Key")
            print(groupUserDefaults?.object(forKey: "Key") as Any)
            groupUserDefaults?.synchronize()
        }
        
        let groupUserDefaults = UserDefaults(suiteName: defaultGroup)
        let modelType = groupUserDefaults?.object(forKey: "Key") as? String
        print(groupUserDefaults?.object(forKey: "Key") as Any)
        
        // Determine modelType and tokenAmount
        switch modelType {
        case "Plus":
            return .curie
        case "Pro":
            return .curie
        case "Max":
            return .gpt3_5Turbo
        case "Ultra":
            return .gpt3_5Turbo
        default:
            return .curie
        }
    }
    
    func tokenAmount() -> Int {
        switch setModelType() {
        case .curie:
            return 500
        case .gpt3_5Turbo:
            return 1500
        default:
            return 200
        }
    }
    
    //MARK: Save user question
    func saveQuestion(moc: NSManagedObjectContext, passQuery: String) {
        let user = ConversationUser(context: moc)
        user.userId = user.userId + 1 // Assign a unique ID to the user
        user.userTime = Date()
        user.userInput = passQuery
        try? moc.save()
    }
    
    //MARK: Process and save Boston response
    func askBoston(moc: NSManagedObjectContext, passQuery: String, isAskingBoston: Binding<Bool>, completion: @escaping (String?) -> Void) {
        let modelType = setModelType()
        let tokenAmount = tokenAmount()
        
        isAskingBoston.wrappedValue = true
        
        if modelType == .curie {
            openAI.completions(query: .init(
                model: modelType,
                prompt: passQuery,
                temperature: 0.56,
                max_tokens: tokenAmount,
                top_p: 1,
                frequency_penalty: 0.8,
                presence_penalty: 1,
                stop: ["\\n"])) { result in
                    switch result {
                    case .success(let response):
                        var outputText = response.choices.first?.text
                        
                        let boston = ConversationBoston(context: moc)
                        boston.bostonId = boston.bostonId + 1 // Assign a unique ID to the Boston response
                        boston.bostonTime = Date()
                        
                        if outputText?.first == "?" || outputText?.first == "\n" {
                            outputText = String((outputText?.dropFirst())!)
                        }
                        
                        boston.bostonOutput = outputText!
                        try? moc.save()
                        
                        isAskingBoston.wrappedValue = false
                        
                        print(outputText!)
                        print(response)
                        completion(outputText)
                        
                    case .failure(let error):
                        print(error)
                        isAskingBoston.wrappedValue = false
                        completion(nil)
                        
                        let boston = ConversationBoston(context: moc)
                        boston.bostonId = boston.bostonId + 1 // Assign a unique ID to the Boston response
                        boston.bostonTime = Date()
                        
                        boston.bostonOutput = "There was an error, please send a bug report to the developer!"
                        try? moc.save()
                    }
                }
        } else {
            openAI.chats(query: .init(
                model: modelType,
                messages: [.init (role: "user", content: passQuery)],
                temperature: 0.56,
                top_p: 1,
                stop: ["\\n"],
                max_tokens: tokenAmount,
                presence_penalty: 1,
                frequency_penalty: 0.8)) { result in
                    switch result {
                    case .success(let response):
                        var outputText = response.choices.first?.message.content
                        
                        let boston = ConversationBoston(context: moc)
                        boston.bostonId = boston.bostonId + 1 // Assign a unique ID to the Boston response
                        boston.bostonTime = Date()
                        
                        if outputText?.first == "?" || outputText?.first == "\n" {
                            outputText = String((outputText?.dropFirst())!)
                        }
                        
                        boston.bostonOutput = outputText!
                        try? moc.save()
                        
                        isAskingBoston.wrappedValue = false
                        
                        print(outputText!)
                        completion(outputText)
                        
                    case .failure(let error):
                        print(error)
                        isAskingBoston.wrappedValue = false
                        completion(nil)
                        
                        let boston = ConversationBoston(context: moc)
                        boston.bostonId = boston.bostonId + 1 // Assign a unique ID to the Boston response
                        boston.bostonTime = Date()
                        
                        boston.bostonOutput = "There was an error, please send a bug report to the developer!"
                        try? moc.save()
                    }
                }
        }
    }
}
