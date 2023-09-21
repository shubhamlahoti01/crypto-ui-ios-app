//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by Shubham Lahoti on 20/09/23.
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
//    @StateObject private var vm = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
//            .environmentObject(vm)
        }
    }
}
