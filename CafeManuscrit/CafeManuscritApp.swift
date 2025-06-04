//
//  CafeManuscritApp.swift
//  CafeManuscrit
//
//  Created by 고재민 on 6/1/25.
//

import SwiftUI
import SwiftData

@main
struct CafeManuscritApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(SwiftDataManager.shared.container)
    }
}
