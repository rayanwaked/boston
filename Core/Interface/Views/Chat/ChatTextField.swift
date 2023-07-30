//
//  ChatTextField.swift
//  Boston
//
//  Created by Rayan Waked on 3/10/23.
//

import SwiftUI
import StoreKit
import OpenAI

struct ChatTextField: View {
    @State private var textField: String = ""
    @State var isAskingBoston = false
    
    @Environment(\.managedObjectContext) var moc
    
    // Private variable to hold the ChatFunctionality instance
    private var chatFunctionality: ChatFunctionality {
        return ChatFunctionality()
    }
     
    //MARK: TextField view
    var body: some View {
        ZStack(alignment: .leading) {
            if textField.isEmpty {
                Text(isAskingBoston ? "    Thinking..." : "    Ask Boston a question")
                    .foregroundColor(isAskingBoston ? .gray : .dogWood)
                    .padding()
            }
            
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 45)
                .foregroundColor(isAskingBoston ? .gray.opacity(0.4) : .black.opacity(0.4))
                .cornerRadius(15)
                .padding()
            
            TextField("", text: $textField)
                .foregroundColor(.dogWood)
                .tint(Color.dogWood)
                .padding()
                .padding([.leading, .trailing], 16)
                .onSubmit {
                    let query = textField
                    textField = ""
                    
                    chatFunctionality.saveQuestion(moc: moc, passQuery: query)
                    
                    isAskingBoston = true
                    chatFunctionality.askBoston(moc: moc, passQuery: query, isAskingBoston: $isAskingBoston) { outputText in
                        isAskingBoston = false
                        if let outputText = outputText {
                            print(outputText)
                        }
                    }
                }
                .disabled(isAskingBoston)
        }
        .background(Color.darkOxfordBlue)
    }
}

struct ChatTextField_Previews: PreviewProvider {
    static var previews: some View {
        ChatTextField()
    }
}
