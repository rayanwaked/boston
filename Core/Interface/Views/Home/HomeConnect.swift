//
//  HomeConnectView.swift
//  Boston
//
//  Created by Rayan Waked on 2/16/23.
//

import SwiftUI

struct HomeConnect: View {
    var shortcut: ShortcutManager.Shortcut?
    
    var body: some View {
        VStack {
            Text("Connect")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if ProcessInfo.processInfo.isiOSAppOnMac == false {
                Text("Once you've verified Shortcuts is installed, press the button below to add Boston to your Shortcuts.")
                    .fixedSize(horizontal: false,
                               vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .padding(.bottom, -2)
            } else {
                Text("To add Boston to your Shortcuts, click the button below and following the instructions.")
                    .fixedSize(horizontal: false,
                               vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .padding(.bottom, -2)
            }
            
            ZStack {
                SiriShortcutView(shortcut: ShortcutManager.Shortcut.prompt)
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.darkOxfordBlue)
                    .allowsHitTesting(false)
                Text("Add Boston to Your Shortcuts")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.dogWood)
                    .fontWeight(.bold)
                    .allowsHitTesting(false)
            }
            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
        }
    }
}

struct HomeConnect_Previews: PreviewProvider {
    static var previews: some View {
        HomeConnect()
    }
}
