//
//  ContentView.swift
//  ios-app-preview
//
//  Created by Hectar Carson on 3/15/25.
//

import SwiftUI
import SwiftData
import Charts
import Foundation
import Combine

// ViewModel
class UserViewModel: ObservableObject {
    @Published var userName: String = "Alice"
    @Published var employeeUserName: String = "Emily"
    @Published var superEmployeeUserName: String = "Aaron"
    @Published var currentTimeOfDay: String = ""
    @Published var userEmail: String = "alicehomes@denver.com"
    @Published var selectedService: String = ""
    
    let services = [
        "Moving",
        "Groceries",
        "Ski Tuning",
        "Home Organization",
        "Pet Care",
        "Flower delivery",
        "TV & Art Mounting",
        "Maintenance Requests",
        "Other"
    ]
    
    init() {
        setTimeOfDayGreeting()
    }
    
    // function to return a greeting based on time of day
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour < 12 {
            return "Good morning,"
        } else if hour < 18 {
            return "Good afternoon,"
        } else {
            return "Good evening,"
        }
    }
    
    // setting the time of day for the greeting
    private func setTimeOfDayGreeting() {
        let currentHour = Calendar.current.component(.hour, from: Date())
        if currentHour < 12 {
            currentTimeOfDay = "Morning"
        } else if currentHour < 18 {
            currentTimeOfDay = "Afternoon"
        } else {
            currentTimeOfDay = "Evening"
        }
    }
    
    // add a timer to update the time-dependent greeting dynamically
    func startTimeUpdate() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.setTimeOfDayGreeting()
        }
    }
}

// main
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {
            VStack {
                // background image !!
                // change font to Poppins!!!
                Image("interior")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
                    .overlay (
                        // linear gradient fade
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0), Color.white.opacity(1)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .mask(
                            Image("interior")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        )
                    )
                // login forms
                VStack(alignment: .center) {
                    HStack(spacing: 0) {
                        Text("ALICE")
                            .font(.largeTitle)
                            .fontWeight(.ultraLight)
                            .foregroundColor(Color.gray)
                        
                        Text(" HOMES")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.gray)
                    }
                    
                    VStack(spacing: 25) {
                        // username
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(1)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.horizontal, 30)
                            .disableAutocorrection(true)
                        
                        // password
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(1)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.horizontal, 30)
                        
                        // login button
                        Button(action: {
                            print("Logging in with username: \(username) and password: \(password)")
                        }) {
                            Text("Login")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(1)
                                .padding(.horizontal, 30)
                        }
                    }
                    .padding(.top, 30)
                    .cornerRadius(5)
                    .padding(.bottom, 400)
                }
                .padding(.top, 50)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
