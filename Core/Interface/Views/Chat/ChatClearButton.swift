//
//  ChatClearButton.swift
//  Boston
//
//  Created by Rayan Waked on 3/11/23.
//

import SwiftUI
import CoreData

struct ChatClearButton: View {
    @Environment(\.managedObjectContext) var moc
    @Binding var shouldReload: Bool
    
    let icon: Image
    let clearer: CoreDataClearer

    init(icon: Image, shouldReload: Binding<Bool>, clearer: CoreDataClearer) {
        self.icon = icon
        _shouldReload = shouldReload
        self.clearer = clearer
    }

    var body: some View {
        Button {
            clearer.clearCoreData(moc: moc, shouldReload: $shouldReload)
        } label: {
            ZStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.darkOxfordBlue)
                icon
                    .foregroundColor(.dogWood)
                    .fontWeight(.bold)
            }
        }
    }
}
