//
//  HomeView.swift
//  Boston
//
//  Created by Rayan Waked on 2/7/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var firstLaunch = FirstLaunch()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text("Setup")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 20)
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            if firstLaunch.isFirstLaunch {
                                firstLaunch.isFirstLaunch = false
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(.dogWood)
                                if firstLaunch.isFirstLaunch {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.darkOxfordBlue)
                                        .fontWeight(.bold)
                                } else {
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.darkOxfordBlue)
                                        .fontWeight(.bold)
                                }
                            }
                            .padding(.leading, 20)
                            .padding(.top, -15)
                        }
                    }
                    .padding(.top, 20)
                        
                    StoreAdvertisement()
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.dogWood)
                        .foregroundColor(.oxfordBlue)
                        .cornerRadius(20)
                        .padding(.bottom, 10)
                    
                    if ProcessInfo.processInfo.isiOSAppOnMac == false {
                        HomePrepare()
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.darkOxfordBlue)
                            .cornerRadius(20)
                    }
                    
                    HomeConnect()
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.darkOxfordBlue)
                        .cornerRadius(20)
                    
                    HomeIntructions()
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.darkOxfordBlue)
                        .cornerRadius(20)
                    
                    HomeContact()
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.darkOxfordBlue)
                        .cornerRadius(20)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding([.leading, .trailing], 20)
            }
            .background(Color.oxfordBlue)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
    
