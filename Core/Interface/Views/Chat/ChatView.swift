//
//  ChatView.swift
//  Boston
//
//  Created by Rayan Waked on 3/10/23.
//

import SwiftUI
import SwiftUIX
import CoreData

class FirstView: ObservableObject {
    @AppStorage("isFirstView") var isFirstView = true
}

struct ChatView: View {
    @StateObject var firstView = FirstView()
    @State private var shouldReload = false
    @State var reloader = 0
    
    let clearer = CoreDataClearer()
    
        var body: some View {
            NavigationView() {
                VStack {
                    //MARK: Navigation Bar
                    HStack {
                        Text("Boston")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ChatClearButton(icon: Image(systemName: "trash.fill"), shouldReload: $shouldReload, clearer: clearer)

                        ChatNavigationButton(destination: HomeView(), icon: Image(systemName: "gearshape.fill"))
                        
                        ChatNavigationButton(destination: StoreView(), icon: Image(systemName: "star.fill"))
                    }
                    .padding()
                    
                    //MARK: Chat view
                    ScrollView {
                        ChatSetup()
                    }
                    .id(reloader)
                    .padding(.bottom, -10)
                    .onChange(of: shouldReload) { _ in
                        reloader += 1
                        shouldReload = false
                    }
                    .onAppear {
                        if firstView.isFirstView {
                            requestReview()
                            firstView.isFirstView = false
                        }
                    }
                    
                    //MARK: Textfield
                    ChatTextField()
                }
                .background(Color.oxfordBlue)
                .padding(.keyboard)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                .simultaneousGesture(TapGesture().onEnded{
                    UIApplication.shared.endEditing()
                })
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

//MARK: Close Keyboard On Tap
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
