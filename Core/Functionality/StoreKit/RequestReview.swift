//
//  RequestReview.swift
//  Boston
//
//  Created by Rayan Waked on 3/14/23.
//

// MARK: - IMPORT
import StoreKit

// MARK: - REQUEST USER REVIEW
func requestReview() {
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        SKStoreReviewController.requestReview(in: scene)
    }
}
