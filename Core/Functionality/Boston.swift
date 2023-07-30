//
//  BostonApp.swift
//  Boston
//
//  Created by Rayan Waked on 1/15/23.
//

import SwiftUI
import Intents
import OpenAI

class FirstLaunch: ObservableObject {
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
}

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
