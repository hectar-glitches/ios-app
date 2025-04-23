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

// client view
struct ServiceDetailView: View {
    var service: String
    var serviceDescription: String
    
    var body: some View {
        ScrollView {
            VStack {
                Text(service)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text(serviceDescription)
                    .font(.body)
                    .padding()
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("Service Details", displayMode: .inline)
    }
}

// snapshot view of the services
// future to include: weather alerts for pet care and ski tuning, preferred stores for groceries, more moving details

struct ServicesView: View {
    @StateObject var networkManager = NetworkManager()
    @StateObject var userViewModel = UserViewModel()
    
    @State private var showReviewSheet = false
    @State private var showContactSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("\(userViewModel.getGreeting()) \(userViewModel.userName) !")
                        .font(.title .bold())
                        .foregroundStyle(.black)
                        .padding(.top, 1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        ForEach(userViewModel.services, id: \.self) { service in
                            let symbolName = getSymbolName(for: service)
                            
                            if let serviceDescription = networkManager.serviceDetails[service] {
                                NavigationLink(destination: ServiceDetailView(service: service, serviceDescription: serviceDescription)) {
                                    HStack {
                                        Image(systemName: symbolName)
                                            .font(.title2)
                                            .foregroundColor(.brown)
                                        Text(service)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.brown)
                                        Spacer()
                                        Text("Tap for Details")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showReviewSheet.toggle()
                        }) {
                            Text("Leave a Review")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .padding(.horizontal, 30)
                        }
                        .padding(.top, 20)

                        Spacer()

                        Button(action: {
                            showContactSheet.toggle()
                        }) {
                            Text("Contact Us")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .padding(.horizontal, 30)
                        }
                        .padding(.top, 20)

                        Spacer()
                    }
                }
                .padding()
            }
            .navigationTitle("Services Snapshot")
        }
        .onAppear {
            networkManager.fetchData()
        }
        .actionSheet(isPresented: $showReviewSheet) {
            ActionSheet(
                title: Text("Review"),
                message: Text("We value your feedback!"),
                buttons: [
                    .default(Text("Submit")) {
                        // handle review submission here
                    },
                    .cancel()
                ]
            )
        }
        .actionSheet(isPresented: $showContactSheet) {
            ActionSheet(
                title: Text("Contact Us"),
                message: Text("Please let us know how we can assist you."),
                buttons: [
                    .default(Text("Contact")) {
                        // handle contacting staff here
                    },
                    .cancel()
                ]
            )
        }
    }
    
    func getSymbolName(for service: String) -> String {
        switch service {
        case "Moving":
            return "arrow.triangle.turn.up.right.circle"
        case "Groceries":
            return "cart.fill"
        case "Ski Tuning":
            return "figure.skiing.downhill"
        case "Home Organization":
            return "homekit"
        case "Pet Care":
            return "pawprint.fill"
        case "Flower delivery":
            return "sunflower"
        case "TV & Art Mounting":
            return "tv"
        case "Maintenance Requests":
            return "wrench"
        default:
            return "questionmark.circle"
        }
    }
}

struct ServiceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesView()
    }
}
