//
//  BostonApp.swift
//  Boston
//
//  Created by Rayan Waked on 1/15/23.
//

// MARK: - IMPORT
import SwiftUI
import Intents
import OpenAI

// MARK: - APP STORAGE
class FirstLaunch: ObservableObject {
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
}

// MARK: - MAIN
@main
struct BostonApp: App {
    @StateObject var firstLaunch = FirstLaunch()
    @StateObject private var dataController = DataController()
    @Environment(\.scenePhase) private var scenePhase
    let store = Store()
    
    var body: some Scene {
        WindowGroup {
            if firstLaunch.isFirstLaunch {
                HomeView()
                    .environmentObject(store)
                    .preferredColorScheme(.dark)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
            } else {
                ChatView()
                    .environmentObject(store)
                    .preferredColorScheme(.dark)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
            }
        }
        .onChange(of: scenePhase) { phase in
                   INPreferences.requestSiriAuthorization({status in
                   // Handle errors here
               })
           }
    }
}
