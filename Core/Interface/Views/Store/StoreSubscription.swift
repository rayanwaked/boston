//
//  StoreView.swift
//  Boston
//
//  Created by Rayan Waked on 2/18/23.
//

import StoreKit
import SwiftUI

struct StoreSubscription: View {
    @ObservedObject var store = StoreManager.shared.store
    @State var currentSubscription: Product?
    @State var status: Product.SubscriptionInfo.Status?

    var availableSubscriptions: [Product] {
        store.subscriptions.filter { $0.id != currentSubscription?.id }
    }

    var body: some View {
        Group {
            if let currentSubscription = currentSubscription {
                VStack() {
                    StoreListCell(product: currentSubscription, purchasingEnabled: false)

                    if let status = status {
                        StoreStatus(product: currentSubscription,
                                        status: status)
                    }
                }
                .listStyle(GroupedListStyle())
            }

            Section() {
                ForEach(availableSubscriptions) { product in
                    StoreListCell(product: product)
                }
            }
            .listStyle(GroupedListStyle())
        }
        .onAppear {
            Task {
                //When this view appears, get the latest subscription status.
                await updateSubscriptionStatus()
            }
        }
        .onChange(of: store.purchasedSubscriptions) { _ in
            Task {
                //When `purchasedSubscriptions` changes, get the latest subscription status.
                await updateSubscriptionStatus()
            }
        }
    }

    @MainActor
    func updateSubscriptionStatus() async {
        do {
            //This app has only one subscription group, so products in the subscriptions
            //array all belong to the same group. The statuses that
            //`product.subscription.status` returns apply to the entire subscription group.
            guard let product = store.subscriptions.first,
                  let statuses = try await product.subscription?.status else {
                return
            }

            var highestStatus: Product.SubscriptionInfo.Status? = nil
            var highestProduct: Product? = nil
            
            //Iterate through `statuses` for this subscription group and find
            //the `Status` with the highest level of service that isn't
            //in an expired or revoked state. For example, a customer may be subscribed to the
            //same product with different levels of service through Family Sharing.
            for status in statuses {
                switch status.state {
                case .expired, .revoked:
                    continue
                default:
                    let renewalInfo = try store.checkVerified(status.renewalInfo)

                    //Find the first subscription product that matches the subscription status renewal info by comparing the product IDs.
                    guard let newSubscription = store.subscriptions.first(where: { $0.id == renewalInfo.currentProductID }) else {
                        continue
                    }

                    guard let currentProduct = highestProduct else {
                        highestStatus = status
                        highestProduct = newSubscription
                        continue
                    }
                    
                    let highestTier = store.tier(for: currentProduct.id)
                    let newTier = store.tier(for: renewalInfo.currentProductID)

                    if newTier > highestTier {
                        highestStatus = status
                        highestProduct = newSubscription
                    }
                }
            }
            
            status = highestStatus
            currentSubscription = highestProduct
            
            let groupUserDefaults = UserDefaults(suiteName: defaultGroup)
            groupUserDefaults?.set((highestProduct?.displayName ?? "None") as String, forKey: "Key")
            print(groupUserDefaults?.object(forKey: "Key") as Any)
            groupUserDefaults?.synchronize()
            
        } catch {
            print("Could not update subscription status \(error)")
        }
    }
}
