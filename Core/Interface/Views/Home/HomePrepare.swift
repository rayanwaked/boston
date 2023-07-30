//
//  HomeStartView.swift
//  Boston
//
//  Created by Rayan Waked on 2/16/23.
//

import SwiftUI

struct HomePrepare: View {
    var isiOSAppOnMac = false
    
    var body: some View {
        VStack {
                Text("Prepare")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Before setting up Boston, make sure you have the Shortcuts app installed.")
                    .fixedSize(horizontal: false,
                               vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                
                Button {
                    openAppStore()
                } label: {
                    Text("Open Shortcuts in the App Store")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.dogWood)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                }
        }
    }
}

struct HomePrepare_Previews: PreviewProvider {
    static var previews: some View {
        HomePrepare()
    }
}

//MARK: Open App Store Modal
func openAppStore() {
    if let url = URL(string: "itms-apps://apps.apple.com/app/id915249334") {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
