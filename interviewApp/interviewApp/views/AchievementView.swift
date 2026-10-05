import SwiftUI

// Define a model for the achievement
struct Achievement: Identifiable {
    var id = UUID()
     var title: String
     var description: String
     var date: String
     var isCompleted: Bool
}

// Define the AchievementView
struct AchievementView: View {
    // Example achievements
    @StateObject private var model = AchievementModel()
    

    private let gridItems = Array(repeating: GridItem(.flexible(), spacing: 20), count: 3) // Adjust for desired column count

    var body: some View {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let safeAreaTopPadding = windowScene?.windows.first?.safeAreaInsets.top ?? 0
        ZStack (alignment: .top){

            ScrollView {
                
                Text("ACHIEVEMENTS")
                    .font(.system(size: 24)) // Set the font size
                    .fontWeight(.bold) // Make the font bold
                    .foregroundColor(.black) // Set the text color to white
                //.padding(.top,10)
                    .padding(.top, safeAreaTopPadding/4)
                LazyVStack(spacing: 20) {
                    ForEach(model.achievements) { achievement in
                        
                        AchievementViewTemplate(
                            date: achievement.date,
                            achievementTitle: achievement.title,
                            achievementDescription: achievement.description,
                            achievementCompleted: achievement.isCompleted
                        )
                        
                        
                    }
                    .cornerRadius(8)
                    
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
                
            }
            // without this padding it doesnt use the safe area
            .padding(.bottom, 5) // Adjust this value as needed to account for the tab bar height
            .background(Color.gray.opacity(0.1))
            .onAppear(){
                self.model.loadData()
                // print("ach appeared")
            }
        }
    }
}




