//
//  BuyButtonView.swift
//  Boston
//
//  Created by Rayan Waked on 2/21/23.
//

import StoreKit
import SwiftUI

struct StoreBuyButton: ButtonStyle {
    let isPurchased: Bool

    init(isPurchased: Bool = false) {
        self.isPurchased = isPurchased
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        var bgColor: Color = isPurchased ? Color.green : Color.darlingBlue
        bgColor = configuration.isPressed ? bgColor.opacity(0.7) : bgColor.opacity(1)

        return configuration.label
            .padding(10)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct StoreBuyButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Button(action: {}) {
                Text("Buy")
                    .foregroundColor(.white)
                    .bold()
                    .padding()
            }
            .buttonStyle(StoreBuyButton())
            .previewDisplayName("Normal")
            
            Button(action: {}) {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
            }
            .buttonStyle(StoreBuyButton(isPurchased: true))
            .previewDisplayName("Purchased")
        }
    }
}
