import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0 // Default selected tab
    @State private var showTabView = true // Shared state
    
    var body: some View {
            TabView(selection: $selectedTab) {
                // Home Tab
                // Pass showTabView as a binding to HomeView
                HomeView(showTabView: $showTabView)
                    .tabItem {
                        if showTabView {
                            VStack {
                                Image(systemName: "house")
                                Text("Home")
                            }
                        }
                        
                    }
                    .tag(0)
                    .contentShape(Rectangle()) // Make the entire tab item tappable

                // ProfilePageView Tab
                ProfilePageView(showTabView: $showTabView)
                    .onAppear {
                        let profileModel = ProfilePageModel()
                        profileModel.updateValues()
                        print("showTabView \(showTabView)")
                    }
                    .tabItem {
                        if showTabView {
                            VStack {
                                Image(systemName: "person.circle")
                                Text("Profile")
                            }
                        }
                        
                    }
                    .tag(1)
                    .contentShape(Rectangle()) // Make the entire tab item tappable
                
                // Statistics Tab güncellenmiyor geçişlerde
                AllTestStatisticsView() // Pass the DataManager instance
                    .onAppear {
                        let allStaticsModel = AllTestStatisticsModel()
                        allStaticsModel.updateValues()
                    }
                    .tabItem {
                        ZStack {
                            if showTabView {
                            VStack {
                                Image(systemName: "chart.bar")
                                Text("Statistics")
                            }
                        }
                          }
                          
                    }
                    .tag(2)
                    .contentShape(Rectangle()) // Make the entire tab item tappable
                
                // AchievementView Tab
                AchievementView()
                    .tabItem {
                        if showTabView {
                            VStack {
                                Image(systemName: "trophy.fill")
                                Text("Achievements")
                            }
                        }
                        
                    }
                    .tag(3)
                    .contentShape(Rectangle()) // Make the entire tab item tappable
                    
            }
         
        //.disabled()
        //.accentColor(.white)
    }
    
    struct MainView_Previews: PreviewProvider { // Use a different name for this struct
        static var previews: some View {
            MainView()
        }
    }
    
}
