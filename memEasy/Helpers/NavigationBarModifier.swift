//
//  NavigationBarModifier.swift
//  memEasy
//
//  Created by Andy Do on 11/7/24.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.shadowColor = .clear
        coloredAppearance.shadowImage = UIImage()
        
        // Set title color
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "MainColor") ?? .black]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "MainColor") ?? .black]
        
        // Configure back button
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "MainColor") ?? .black]
        coloredAppearance.buttonAppearance = buttonAppearance
        
        // Apply the appearance to all states
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        // Set the tint color for the back button and other navigation items
        UINavigationBar.appearance().tintColor = UIColor(named: "MainColor")
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func configureNavigationBar() -> some View {
        self.modifier(NavigationBarModifier())
    }
}
