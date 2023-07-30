//
//  RequestReview.swift
//  Boston
//
//  Created by Rayan Waked on 3/14/23.
//

import StoreKit

func requestReview() {
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        SKStoreReviewController.requestReview(in: scene)
    }
}
