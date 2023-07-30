//
//  HomeHelpView.swift
//  Boston
//
//  Created by Rayan Waked on 2/16/23.
//

import SwiftUI

struct HomeContact: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            Text("Contact")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("If you are having issues setting up your app, or would like to reach out for any other reason, please send an email to **rayan@waked.dev**")
                .fixedSize(horizontal: false,
                           vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accentColor(.white)
                .padding(.bottom, 10)
            
            Text("Email Developer")
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.dogWood)
                .fontWeight(.bold)
                .padding(.bottom, 10)
                .onTapGesture {
                    openMail(emailTo: "rayan@waked.dev",
                             subject: "Boston Support",
                             body: "")
                }
        }
    }
}

struct HomeContact_Previews: PreviewProvider {
    static var previews: some View {
        HomeContact()
    }
}

//MARK: Open Mail App
func openMail(emailTo:String, subject: String, body: String) {
    if let url = URL(string: "mailto:\(emailTo)?subject=\(subject.fixToBrowserString())&body=\(body.fixToBrowserString())"),
       UIApplication.shared.canOpenURL(url)
    {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension String {
    func fixToBrowserString() -> String {
        self.replacingOccurrences(of: ";", with: "%3B")
            .replacingOccurrences(of: "\n", with: "%0D%0A")
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: "!", with: "%21")
            .replacingOccurrences(of: "\"", with: "%22")
            .replacingOccurrences(of: "\\", with: "%5C")
            .replacingOccurrences(of: "/", with: "%2F")
            .replacingOccurrences(of: "‘", with: "%91")
            .replacingOccurrences(of: ",", with: "%2C")
            //more symbols fixes here: https://mykindred.com/htmlspecialchars.php
    }
}
