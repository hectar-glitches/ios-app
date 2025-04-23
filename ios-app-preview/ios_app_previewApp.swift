//
//  ios_app_previewApp.swift
//  ios-app-preview
//
//  Created by Hectar Carson on 3/16/25.
//

import SwiftUI
import SwiftData

@main
struct ios_app_previewApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject var viewModel = UserViewModel()
    @StateObject var networkManager = NetworkManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkManager)
                .environmentObject(viewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
