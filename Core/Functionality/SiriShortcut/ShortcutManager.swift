//
//  ShortcutManager.swift
//  Boston
//
//  Created by Rayan Waked on 1/19/23.
//

// MARK: - IMPORT
import Intents

// MARK: - SHORTCUT MANAGER
@available(iOS 12.0, *)
public final class ShortcutManager {
    
    // MARK: Properties
    /// A shared shortcut manager.
    public static let shared = ShortcutManager()
    
    func donate(_ intent: INIntent, id: String? = nil) {
        // create a Siri interaction from our intent
        let interaction = INInteraction(intent: intent, response: nil)
        if let id = id {
            interaction.groupIdentifier = id
        }
        
        // donate it to the system
        interaction.donate { error in
            // if there was an error, print it out
            if let error = error {
                print(error) 
            }
        }
        
        if let shortcut = INShortcut(intent: intent) {
            let relevantShortcut = INRelevantShortcut(shortcut: shortcut)
            INRelevantShortcutStore.default.setRelevantShortcuts([relevantShortcut]) { error in
                if let error = error {
                    print("Error setting relevant shortcuts: \(error)")
                }
            }
        }
    }
    
    public enum Shortcut {
        case prompt
        
        var intent: INIntent {
            var intent: INIntent
            switch self {
            case .prompt:
                intent = PromptIntent()
            }
            intent.suggestedInvocationPhrase = suggestedInvocationPhrase
            return intent
        }
        
        var suggestedInvocationPhrase: String {
            switch self {
            case .prompt: return "Boston"
            }
        }
        
        func donate() {
            // create a Siri interaction from our intent
            let interaction = INInteraction(intent: self.intent, response: nil)
            
            // donate it to the system
            interaction.donate { error in
                // if there was an error, print it out
                if let error = error {
                    print(error)
                }
            }
            
            
            if let shortcut = INShortcut(intent: intent) {
                let relevantShortcut = INRelevantShortcut(shortcut: shortcut)
                INRelevantShortcutStore.default.setRelevantShortcuts([relevantShortcut]) { error in
                    if let error = error {
                        print("Error setting relevant shortcuts: \(error)")
                    }
                }
            }
            
        }
    }
}
