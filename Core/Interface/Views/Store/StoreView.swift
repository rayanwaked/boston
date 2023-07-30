//
//  StoreView.swift
//  Boston
//
//  Created by Rayan Waked on 2/21/23.
//

import SwiftUI
import StoreKit

struct StoreView: View {
    @ObservedObject var store = StoreManager.shared.store
    @Environment(\.openURL) var openURL
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text("Models")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 20)
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(.dogWood)
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.darkOxfordBlue)
                                    .fontWeight(.bold)
                            }
                            .padding(.leading, 20)
                            .padding(.top, -15)
                        }
                    }
                    .padding(.top, 20)
                    
                    StoreSubscription()
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.darkOxfordBlue)
                        .cornerRadius(20)
                    
                    Text("Free model is subject to a 150 word limit")
                        .padding(.bottom, 20)
                    
                    Button("Restore Purchases", action: {
                        Task {
                            try? await AppStore.sync()
                        }
                    })
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.dogWood)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    
                    HStack {
                        Button("EULA Agreement", action: {
                            openURL(URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                        })
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.dogWood)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        
                        Button("Privacy Policy", action: {
                            openURL(URL(string: "https://www.freeprivacypolicy.com/live/aa3be1e5-c41c-43f1-be23-a028504997ef")!)
                        })
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.dogWood)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    }
                    .padding(.top, 10)
                }
                .padding([.leading, .trailing], 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.oxfordBlue)
            .foregroundColor(.white)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline) 
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StoreView_Previews: PreviewProvider {
    @StateObject static var store = Store()
    
    static var previews: some View {
        StoreView()
            .environmentObject(store)
    }
}
