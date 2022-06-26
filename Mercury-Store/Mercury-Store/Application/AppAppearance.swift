//
//  AppAppearance.swift
//  Mercury-Store
//
//  Created by mac hub on 16/05/2022.
//

import Foundation
import UIKit

final class AppAppearance {
    
    static func setupAppearanceForNavigation() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: ColorsPalette.lightColor]
            appearance.backgroundColor = ColorsPalette.labelColors
            UINavigationBar.appearance().tintColor = ColorsPalette.lightColor
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().barTintColor = ColorsPalette.lightColor
            UINavigationBar.appearance().tintColor = ColorsPalette.lightColor
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorsPalette.lightColor]
        }
    }
    
    static func setupAppearanceForTabbar() {
        if #available(iOS 15, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorsPalette.lightColor]
            appearance.backgroundColor = ColorsPalette.labelColors
            appearance.selectionIndicatorTintColor = ColorsPalette.lightColor
            UITabBar.appearance().tintColor = ColorsPalette.lightColor
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UITabBar.appearance().barTintColor = ColorsPalette.labelColors
            UITabBar.appearance().tintColor = ColorsPalette.labelColors
        }
    }
}

extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UITabBarController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


