import SwiftUI
// Template for 3rd Tab Show Statistics of All Tests
struct AllTestStatistics: View {
    // Variables to show
    var testIdName: String
    var date: String
    var experience: String
    var accuracyCount: Int
    var totalQuestion : Int
    
    
    var body: some View {
        
        VStack {
            HStack {
                Text("#")
                //                            .font(.headline)
                Text(testIdName)
                    .foregroundColor(Color.orange)
                    .font(.system(size: 14))
                // .padding(.horizontal, 10)
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(date)
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                    Text(experience)
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                }
                Spacer()
                Spacer()
                
                VStack(spacing: 1) {
                    HStack {  // Enclosing in an HStack for closer proximity
                        Text("True: ")
                            .font(.headline)
                        Text(String(accuracyCount))
                            .fontWeight(.bold)
                            .font(.system(size: 14))
                    }
                    HStack {  // Enclosing in an HStack for closer proximity
                        Text("False: ")
                            .font(.headline)
                        Text(String(totalQuestion - accuracyCount))
                            .fontWeight(.bold)
                            .font(.system(size: 14))
                    }
                }
                //                        .padding(.vertical, 20)
                Spacer()
                Spacer()
                
                Text("%:")
                    .font(.headline)
                Text(String(accuracyCount*100/totalQuestion))
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                    .foregroundColor(Color.blue)
                
            }
        }
        
    }
    
}
