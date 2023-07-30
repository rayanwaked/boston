//
//  ListCellView.swift
//  Boston
//
//  Created by Rayan Waked on 2/21/23.
//

import SwiftUI
import StoreKit

struct StoreListCell: View {
    @ObservedObject var store = StoreManager.shared.store
    @State var isPurchased: Bool = false
    @State var errorTitle = ""
    @State var isShowingError: Bool = false

    let product: Product
    let purchasingEnabled: Bool

    var emoji: String {
        store.emoji(for: product.id)
    }

    init(product: Product, purchasingEnabled: Bool = true) {
        self.product = product
        self.purchasingEnabled = purchasingEnabled
    }

    var body: some View {
        HStack {
            Text(emoji)
                .font(.system(size: 50))
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(.trailing, 5)
            
            if purchasingEnabled {
                productDetail
                Spacer()
                buyButton
                    .buttonStyle(StoreBuyButton(isPurchased: isPurchased))
                    .disabled(isPurchased)
            } else {
                productDetail
            }
        }
        .alert(isPresented: $isShowingError, content: {
            Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
        })
    }

    @ViewBuilder
    var productDetail: some View {
        if product.type == .autoRenewable {
            VStack(alignment: .leading) {
                Text(product.displayName)
                    .bold()
                switch product.displayName {
                case "Plus":
                    VStack(alignment: .leading) {
                        Text("\(product.description)")
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("Basic AI Model")
                        }
                        .padding(.top, 5)
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("Limited responses")
                        }
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("Low update priority")
                        }
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("375 word limit")
                        }
                    }
                case "Pro":
                    VStack(alignment: .leading) {
                        Text("\(product.description)")
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("Basic AI Model")
                        }
                        .padding(.top, 5)
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("Decent responses")
                        }
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("Low update priority")
                        }
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("750 word limit")
                        }
                    }
                case "Max":
                    VStack(alignment: .leading) {
                        Text("\(product.description)")
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("Advanced AI Model")
                        }
                        .padding(.top, 5)
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("More Percise")
                        }
                        
                        HStack(alignment: .top) {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("Medium update priority")
                        }
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("750 word limit")
                        }
                    }
                case "Ultra":
                    VStack(alignment: .leading) {
                        Text("\(product.description)")
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("Advanced AI Model")
                        }
                        .padding(.top, 5)
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("More Percise")
                        }
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("Elaborate responses")
                        }
                        
                        HStack(alignment: .top) {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("High update priority")
                        }
                        
                        HStack {
                            Text("·")
                                .foregroundColor(.dogWood)
                            Text("1125 word limit")
                        }
                    }
                default: Text("Error")
                }
            }
        } else {
            Text(product.description)
                .frame(alignment: .leading)
        }
    }

    func subscribeButton(_ subscription: Product.SubscriptionInfo) -> some View {
        let unit: String
        let plural = 1 < subscription.subscriptionPeriod.value
            switch subscription.subscriptionPeriod.unit {
        case .day:
            unit = plural ? "\(subscription.subscriptionPeriod.value) days" : "day"
        case .week:
            unit = plural ? "\(subscription.subscriptionPeriod.value) weeks" : "week"
        case .month:
            unit = plural ? "\(subscription.subscriptionPeriod.value) months" : "month"
        case .year:
            unit = plural ? "\(subscription.subscriptionPeriod.value) years" : "year"
        @unknown default:
            unit = "period"
        }

        return VStack {
            Text(product.displayPrice)
                .foregroundColor(.white)
                .bold()
                .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 3.0, trailing: 0.0))
            Text(unit)
                .foregroundColor(.white)
                .font(.system(size: 12))
                .padding(EdgeInsets(top: -8.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
        }
    }

    var buyButton: some View {
        Button(action: {
            Task {
                await buy()
            }
        }) {
            if isPurchased {
                Text(Image(systemName: "checkmark"))
                    .bold()
                    .foregroundColor(.white)
            } else {
                if let subscription = product.subscription {
                    subscribeButton(subscription)
                } else {
                    Text(product.displayPrice)
                        .foregroundColor(.white)
                        .bold()
                }
            }
        }
        .onAppear {
            Task {
                isPurchased = (try? await store.isPurchased(product)) ?? false
            }
        }
    }

    func buy() async {
        do {
            if try await store.purchase(product) != nil {
                withAnimation {
                    isPurchased = true
                }
            }
        } catch StoreError.failedVerification {
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
        } catch {
            print("Failed purchase for \(product.id): \(error)")
        }
    }
}
