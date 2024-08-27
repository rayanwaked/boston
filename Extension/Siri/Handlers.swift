//
//  IntentHandler.swift
//  SiriGPT
//
//  Created by Rayan Waked on 1/19/23.
//

// MARK: - IMPORT
import Foundation
import Intents
import OpenAI
import StoreKit

//MARK: INTENT HANDLER
class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        guard intent is PromptIntent else {
            fatalError("Unhandled Intent error : \(intent)")
        }
        return PromptIntentHandler()
    }
}

//MARK: PROMPT INTENT HANDLER (API)
class PromptIntentHandler: NSObject, PromptIntentHandling {
    // Update "SK-YOUR-API-KEY" with your OpenAI API key.
    let openAI = OpenAI(apiToken: "SK-YOUR-API-KEY")
    var tokenAmount = 200
    
    //MARK: SET MODEL TYPE FROM SUBSCRIPTION
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
        
        //MARK: DETERMINE MODELS
        switch modelType {
        case "Plus":
            tokenAmount = 500
            return .curie
        case "Pro":
            tokenAmount = 1000
            return .curie
        case "Max":
            tokenAmount = 1000
            return .gpt3_5Turbo
        case "Ultra":
            tokenAmount = 1500
            return .gpt3_5Turbo
        default:
            tokenAmount = 200
            return .curie
        }
    }

    //MARK: PASS INTENT QUERY TO OPENAI
    func handle(intent: PromptIntent, completion: @escaping (PromptIntentResponse) -> Void) {
        if setModelType() == .curie {
            openAI.completions(query: .init(
                model: setModelType(),
                prompt: intent.query!,
                temperature: 0.56,
                max_tokens: tokenAmount,
                top_p: 1,
                frequency_penalty: 0.8,
                presence_penalty: 1,
                stop: ["\\n"])) { result in
                    switch result {
                    case .success(let response):
                        let outputText = response.choices.first?.text
                        completion(.success(answer: outputText!))
                        print(outputText!)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        } else {
            openAI.chats(query: .init(
                model: .gpt3_5Turbo,
                messages: [.init (role: "user", content: intent.query!)],
                temperature: 0.56,
                top_p: 1,
                stop: ["\\n"],
                max_tokens: tokenAmount,
                presence_penalty: 1,
                frequency_penalty: 0.8)) { result in
                    switch result {
                    case .success(let response):
                        let outputText = response.choices.first?.message.content
                        completion(.success(answer: outputText!))
                        print(outputText!)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    //MARK: RESOLVE ERRORS
    func resolveQuery(for intent: PromptIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if intent.query == nil || intent.query!.isEmpty {
            completion(INStringResolutionResult.needsValue())
        } else {
            completion(INStringResolutionResult.success(with: intent.query ?? ""))
        }
    }
}
