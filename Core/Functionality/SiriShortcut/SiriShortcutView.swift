//
//  SiriButtonView.swift
//  Boston
//
//  Created by Rayan Waked on 1/19/23.
//

import SwiftUI
import UIKit
import Intents
import IntentsUI

class SiriShortcutViewController: UIViewController {
    var shortcut: ShortcutManager.Shortcut?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSiriButton(to: view)
    }
    
    func addSiriButton(to view: UIView) {
        #if !targetEnvironment(macCatalyst)
        let button = INUIAddVoiceShortcutButton(style: .automaticOutline)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        view.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
        setupShortcut(to: button)
        #endif
    }
    
    func setupShortcut(to button: INUIAddVoiceShortcutButton?) {
        if let shortcut = shortcut {
            button?.shortcut = INShortcut(intent: shortcut.intent)
            button?.delegate = self
        }
    }
}

struct SiriShortcutView: UIViewControllerRepresentable {
    var shortcut: ShortcutManager.Shortcut?
    
    func makeUIViewController(context: Context) -> SiriShortcutViewController {
        let vc = SiriShortcutViewController()
        vc.shortcut = shortcut
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SiriShortcutViewController, context: Context) {
        uiViewController.shortcut = shortcut
    }
}

