import SwiftUI
import SwiftData
import Charts
import Foundation
import Combine

// NetworkManager for API
class NetworkManager: ObservableObject {
    @Published var monthlyClients: [Int] = []
    @Published var monthlySatisfaction: [Double] = []
    @Published var totalClients: Int = 0
    @Published var addressData: [String: (clients: Int, satisfaction: Double)] = [:]
    @Published var monthlyClientsData: [String: [Int]] = [:]
    @Published var serviceDetails: [String: String] = [:]
    @Published var maintenanceRequests: [String: Int] = [:]
    
    private var cancellables: Set<AnyCancellable> = []
    
    static let shared = NetworkManager()
    
    // function to fetch data
    func fetchData() {
        // simulate a network request with mock data for each address
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // mock delay'
            
            // mock data for each address
            self.addressData = [
                "The Quincy": (clients: 36, satisfaction: 4.5),
                "The Olympian": (clients: 31, satisfaction: 4.0),
                "The Audrey": (clients: 31, satisfaction: 4.3),
                "The Confluence": (clients: 11, satisfaction: 4.7),
                "Noble Old Hampden": (clients: 45, satisfaction: 4.6)
            ]
            // mock number of clients
            self.monthlyClientsData = [
                "The Quincy": [32, 34, 45, 36, 33, 42,36],
                "The Olympian": [1, 10, 12, 21, 31, 50, 31],
                "The Audrey": [17, 28, 37, 39, 38, 37, 32],
                "The Confluence": [21, 42, 40, 49, 41, 32, 11],
                "Noble Old Hampden": [25, 24, 36, 35, 36, 35, 33]
            ]
            
            // mock services
            self.serviceDetails = [
                "Moving": "Help with packing, loading, and unloading your items.",
                "Groceries": "Get fresh groceries delivered to your door.",
                "Ski Tuning": "Tune and maintain your skis or snowboard.",
                "Home Organization": "Organize your home, declutter, and optimize space.",
                "Pet Care": "Professional care for your pets while you're away.",
                "Flower Delivery": "Delivery of fresh, beautiful flowers for any occasion.",
                "TV & Art Mounting": "Install your TV or mount art on your walls.",
                "Maintenance Requests": "Submit maintenance requests for your property.",
                "Other": "We're happy to help you however we can!"
            ]

            self.updateTotalClients()
            self.updateSatisfactionTrend()
        }
    }
    
    private func updateTotalClients() {
        totalClients = addressData.values.reduce(0) { $0 + $1.clients }
    }
    
    private func updateSatisfactionTrend() {
        // mock satisfaction for the past 6 months
        self.monthlySatisfaction = [4.5, 4.3, 4.6, 4.2, 4.8, 4.5]
    }
    
    func submitClientRequest(for area: String) {
        // check the area exists, then update the number of clients
        if var areaData = addressData[area] {
            areaData.clients += 1
            addressData[area] = areaData
            updateTotalClients()  // update the total number of clients
        }
    }
    
    func requestMoreItem(itemName: String, quantity: Int) {
        DispatchQueue.main.async {
            if let currentQuantity = self.maintenanceRequests[itemName] {
                self.maintenanceRequests[itemName] = currentQuantity + quantity
            } else {
                self.maintenanceRequests[itemName] = quantity
            }
            self.objectWillChange.send()
        }
    }

}

struct ResidenceDetailView: View {
    var area: String
    var clientsInArea: Int
    var satisfaction: Double
    @ObservedObject var networkManager: NetworkManager
    
    var body: some View {
        ScrollView {
            VStack {
                titleAndAreaInfo
                metricsSection
                clientsChart
                insightsSection
            }
            .padding()
        }
    }
    
    private var titleAndAreaInfo: some View {
        VStack(alignment: .leading) {
            Text("\(area)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Overview of \(area) Residence")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom)
        }
    }
    
    private var metricsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            clientsInAreaMetric
            satisfactionMetric
        }
        .padding()
    }
    
    private var clientsInAreaMetric: some View {
        HStack {
            Text("Clients in this home:")
                .font(.headline)
            Spacer()
            Text("\(clientsInArea)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(clientsInArea > 20 ? .green : .red)
        }
    }
    
    private var satisfactionMetric: some View {
        HStack {
            Text("Satisfaction:")
                .font(.headline)
            Spacer()
            Text("\(satisfaction, specifier: "%.1f")")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(satisfaction >= 4.5 ? .green : (satisfaction >= 3.0 ? .orange : .red))
        }
    }
    
    private var clientsChart: some View {
        VStack {
            Text("Clients in \(area) over the past months")
                .font(.headline)
                .padding(.top)
            
            // ensure the residence exists in monthlyClientsData
            if let monthlyClients = networkManager.monthlyClientsData[area] {
                Chart {
                    ForEach(monthlyClients.indices, id: \.self) { index in
                        BarMark(
                            x: .value("Month", index),
                            y: .value("Clients", monthlyClients[index])
                        )
                        .foregroundStyle(.brown)
                    }
                }
                .frame(height: 250)
                .padding()
            } else {
                EmptyView()
            }
        }
    }
    
    private var insightsSection: some View {
        VStack {
            Text("Key Insights")
                .font(.headline)
                .padding(.top)
            
            VStack(alignment: .leading) {
                Text("The average stay period of \(area) residents is stable at \(2.0, specifier: "%.1f") months.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if clientsInArea > 50 {
                    Text("Client occupancy is reaching maximum capacity, further expansion may be necessary.")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            }
            .padding(.top)
        }
    }
}

struct SnapshotView: View {
    @StateObject var networkManager = NetworkManager()
    @StateObject var userViewModel = UserViewModel()
    
    // track the total number of clients and pending requests
    @State private var outgoingClients: Int = 3
    @State private var pendingRequests: Int = 40
    @State private var completedRequests: Int = 60
    
    // residences
    @State private var areas = ["The Quincy", "The Olympian", "The Audrey", "The Confluence", "Noble Old Hampden"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("\(userViewModel.getGreeting()) \(userViewModel.superEmployeeUserName) !")
                        .font(.title2 .bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    // request overview
                    HStack {
                        VStack {
                            Text("Total Clients")
                                .font(.subheadline)
                            Text("\(networkManager.totalClients)")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        VStack {
                            Text("Pending Requests")
                                .font(.subheadline)
                            Text("\(pendingRequests)")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        VStack {
                            Text("Outgoing Clients")
                                .font(.subheadline)
                            Text("\(outgoingClients)")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    
                    // displaying addresses
                    Text("Homes")
                        .font(.title3 .bold())
                        .padding(.top, 20)
                    
                    VStack {
                        ForEach(areas, id: \.self) { area in
                            if let data = networkManager.addressData[area] {
                                NavigationLink(destination: ResidenceDetailView(area: area,
                                                                                clientsInArea: data.clients,
                                                                                satisfaction: data.satisfaction,
                                                                                networkManager: networkManager)) {
                                    HStack {
                                        Text(area)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.brown)
                                        Spacer()
                                        Text("\(data.clients) Clients")
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    
                    // satisfaction trend chart
                    Text("Satisfaction Trend")
                        .font(.title3 .bold())
                        .padding(.top)
                    
                    Chart {
                        ForEach(networkManager.monthlySatisfaction.indices, id: \.self) { index in
                            LineMark(
                                x: .value("Month", index),
                                y: .value("Satisfaction", networkManager.monthlySatisfaction[index])
                            )
                        }
                        .foregroundStyle(.brown)
                    }
                    .frame(height: 200)
                    .padding()
                }
                Text("Inventory Requests")
                    .font(.title3 .bold())
                    .padding(.top)
                VStack {
                    ForEach(networkManager.maintenanceRequests.keys.sorted(), id: \.self) { item in
                        if let quantity = networkManager.maintenanceRequests[item] {
                            HStack {
                                Text(item)
                                    .font(.title3)
                                Spacer()
                                Text("Requested: \(quantity)")
                                    .foregroundStyle(.red)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                }
                
                .padding()
            }
            .navigationTitle("Snapshot")
        }
        .onAppear {
            // fetch data when the view appears
            networkManager.fetchData()
        }
    }
    
}
struct SnapshotView_Previews: PreviewProvider {
    static var previews: some View {
        SnapshotView()
    }
}
