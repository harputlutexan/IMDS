import SwiftUI
// Template for 3rd Tab Show Statistics of All Tests
struct AchievementViewTemplate: View {
    // Variables to show
    var date: String
    var achievementTitle: String
    var achievementDescription: String
    var achievementCompleted : Bool
    
    
    var body: some View {
        ZStack{
            
            Color.white
            

        VStack {
            HStack {
                
                Image(systemName: achievementCompleted ? "checkmark.seal.fill" : "lock.fill") // Placeholder, replace with actual logic to select images
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35) // Adjust size as needed
                    .foregroundColor(achievementCompleted ? .green : .red)
               //Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(achievementTitle)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    Text(achievementDescription)
                        //.fontWeight(.bold)
                        .font(.system(size: 14))
                }
                .padding(.bottom, 15)
                .padding(.top, 5) // Aligns the text to the bottom
                Spacer()
                Spacer()
                                
                VStack(alignment: .trailing, spacing: 4) {
                    Spacer() // This will push the text to the bottom
                    Text(achievementCompleted ? date : "Achievement is Not Completed Yet")
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                        .foregroundColor(achievementCompleted ? Color.black : Color.red)
                }
                .padding(.top, 15) // Aligns the text to the bottom
                .padding(.bottom, 5) // Aligns the text to the bottom
            }
            // this padding is for inner HStack, if removes texts start from top and bottom
            //.padding(.vertical, 20)
        }
        .padding(.horizontal, 10)
        }
    }
    
}
