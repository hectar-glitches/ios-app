//
//  EmployeeView.swift
//  ios-app-preview
//
//  Created by Hectar Carson on 3/15/25.
//

import SwiftUI
import SwiftData
import Charts
import Foundation

// employee view
struct EmployeeView: View {
    @StateObject var networkManager = NetworkManager.shared

    @State private var requests: [Task] = [
        Task(name: "Leaking faucet", home: "The Quincy", location: "Apartment 4B", priority: .high, status: .pending, assignedDate: Date(), deadline: Calendar.current.date(byAdding: .day, value: 2, to: Date())!),
        Task(name: "Replace HVAC filter", home: "The Olympian", location: "Main Hall", priority: .medium, status: .inProgress, assignedDate: Date(), deadline: Calendar.current.date(byAdding: .day, value: 5, to: Date())!),
        Task(name: "Repair broken window", home: "The Confluence", location: "Room 516", priority: .low, status: .completed, assignedDate: Date(), deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
    ]

    @State private var inventory: [InventoryItem] = [
        InventoryItem(name: "Hammer", quantity: 5, itemType: "Tool", location: "Toolbox"),
        InventoryItem(name: "HVAC Filters", quantity: 10, itemType: "Material", location: "Storage Room"),
        InventoryItem(name: "Screws (Pack of 100)", quantity: 25, itemType: "Material", location: "Storage Room"),
        InventoryItem(name: "Wrench", quantity: 3, itemType: "Tool", location: "Toolbox")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    pendingTasksSection
                    inventorySection
                }
                .padding()
                .navigationTitle("Dashboard")
            }
        }
    }

    private var pendingTasksSection: some View {
        VStack {
            Text("Maintenance")
                .font(.title .bold())
                .padding()
            Text("Pending Tasks")
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVStack {
                ForEach(requests) { task in
                    taskView(for: task)
                }
            }
        }
    }

    private func taskView(for task: Task) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.name)
                    .fontWeight(.bold)
                Text("Home: \(task.home)")
                    .font(.subheadline)
                Text("Location: \(task.location)")
                    .font(.subheadline)
                Text("Priority: \(task.priority.rawValue)")
                    .font(.subheadline)
                Text("Status: \(task.status.rawValue)")
                    .font(.subheadline)
            }
            Spacer()
            VStack {
                Text("Assigned: \(formattedDate(task.assignedDate))")
                    .font(.caption)
                Text("Deadline: \(formattedDate(task.deadline))")
                    .font(.caption)
            }
        }
        .padding()
        .background(
            task.status == .completed
                ? Color.green.opacity(0.3)
                : (task.status == .inProgress
                       ? Color.brown.opacity(0.2) : Color.white)
            )
        .cornerRadius(8)
    }

    private var inventorySection: some View {
        VStack {
            Text("Inventory")
                .font(.title .bold())
                .padding()
            LazyVStack {
                ForEach(inventory) { item in
                    inventoryView(for: item)
                }
            }
        }
    }

    private func inventoryView(for item: InventoryItem) -> some View {
        HStack {
            Text(item.name)
                .fontWeight(.bold)
            Spacer()
            Text("Qty: \(item.quantity)")
                .font(.subheadline)
            Button(action: {
                requestMoreItem(item)
            }) {
                Text("Request More")
                    .foregroundColor(.blue)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(item.quantity == 0 ? Color.red.opacity(0.3) : Color.white)
        .cornerRadius(8)
    }

    // Simplified function to handle requesting more items
    private func requestMoreItem(_ item: InventoryItem) {
        // For now, we just log the request (you can later update it to request from the backend)
        print("Requesting more of \(item.name). Current quantity: \(item.quantity)")
        // In a real app, here you'd send a request to a server or update the inventory locally.
    }

    // helper functions to format dates
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}


struct Task: Identifiable {
let id = UUID()
let name: String
let home: String
let location: String
let priority: Priority
let status: TaskStatus
let assignedDate: Date
let deadline: Date
}

enum Priority: String {
case high = "High"
case medium = "Medium"
case low = "Low"
}

enum TaskStatus: String {
case pending = "Pending"
case inProgress = "In Progress"
case completed = "Completed"
}

struct InventoryItem: Identifiable {
let id = UUID()
let name: String
let quantity: Int
let itemType: String
let location: String
}

#Preview {
EmployeeView()
}
