import SwiftUI

struct AllTestStatisticsView: View {
    @StateObject var detailedViewModel = AllTestStatisticsModel()
    @State private var listItemTapped: Bool = false
    @AppStorage(DataContractIOS.testDetaiIdPreference) private var tappedItemIndex: Int = 0
    @State private var isListItemPressed: Bool = false
    @State private var pressedItemIndex: Int? = nil
    
    
    // In SwiftUI, you can use the .onAppear modifier to perform actions when a view appears.
    //However, this modifier may not be called every time the tab is selected. Instead, you can use the
    //.onChange modifier to detect changes in the selectedTab state.
    
    var body: some View {
        // var totalQuestion2 : Int = 0
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let safeAreaTopPadding = windowScene?.windows.first?.safeAreaInsets.top ?? 0
        NavigationView {
            ZStack(alignment: .top) {
                Color.gray.opacity(0.1)
                VStack {
                        if detailedViewModel.statisticsDataSummary.isEmpty {
                            Text("NO FINISHED TEST YET")
                                .font(.title2)
                        }
                        // Spacer() // Add a spacer at the top to push the text to the bottom
                        Text("All Quiz Results")
                            .font(.system(size: 24)) // Set the font size
                            .fontWeight(.bold) // Make the font bold
                            .foregroundColor(.black) // Set the text color to white
                            //.padding(.top,10)
                            .padding(.top, safeAreaTopPadding/4)
                        //.fixedSize(horizontal: false, vertical: true) // Allow text to wrap
                        Text("Click on a Quiz t to View\n Its Results")
                            .font(.system(size: 16)) // Set the font size
                        //.fontWeight(.bold) // Make the font bold
                            .foregroundColor(.black) // Set the text color to white
                            .multilineTextAlignment(.center)
                            .padding(.top,1)
                        //.fixedSize(horizontal: false, vertical: true) // Allow text to wrap
                        // Spacer() // Add a spacer at the bottom for better alignment
                    
                    ScrollView {
                        LazyVStack() { // Adjust spacing as needed
                            ForEach(Array(detailedViewModel.statisticsDataSummary.enumerated()), id: \.element.testIdName) { index, data in
                                AllTestStatistics(
                                    testIdName: data.testIdName,
                                    date: data.date,
                                    experience: data.experience,
                                    accuracyCount: data.accuracyCount,
                                    totalQuestion: getTotalQuestions(experience: data.experience)
                                )
                                .onTapGesture {
                                    print("Tapped item at index: \(index)")
                                    self.listItemTapped = true
                                    tappedItemIndex = index + 1
                                }
                                
                                .simultaneousGesture(LongPressGesture(minimumDuration: 0.1).onChanged { _ in
                                    withAnimation(.easeInOut) {
                                        self.pressedItemIndex = index
                                    }
                                }.onEnded { _ in
                                    withAnimation(.easeInOut) {
                                        self.pressedItemIndex = nil
                                    }
                                })
                                
                                
                                // This padding is for inner list items
                                .padding(.vertical, 10)
                                .padding(.horizontal, 5)
                                .background(.white)
                                .cornerRadius(10)
                                .scaleEffect(pressedItemIndex == index ? 0.9 : 1.0) // Apply effect only to the pressed item
                                //.animation(.easeInOut, value: pressedItemIndex)
                            }
                            // this padding is for between list item distances
                            .padding(.vertical, 2)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .shadow(radius: 5)
                            
                        }
                        
                    }
                    NavigationLink("", destination: TestDetailView(), isActive: self.$listItemTapped)
                        .navigationBarBackButtonHidden(true)
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .onAppear {
                    detailedViewModel.updateValues()
                    pressedItemIndex = nil
                }
                //.background(.gray.opacity(0.1))
            }
            .padding(.bottom,10)

        }
        
    }
    
    
    func getTotalQuestions(experience experienceLevel: String)-> Int{
        var totalQuestion2 : Int = 0
        switch experienceLevel {
        case DataContractIOS.EXPERIENCE_BEGINNER_STRING,
            DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING,
            DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING,
            DataContractIOS.EXPERIENCE_ADVANCED_STRING,
            DataContractIOS.EXPERIENCE_EXPERT_STRING:
            totalQuestion2 = DataContractIOS.regularTestsQuestionNumbers
        case DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING1,
            DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING2,
            DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING3:
            totalQuestion2 = DataContractIOS.assessmentQuestionNumbers
        default:
            // Handle default case
            break
        }
        return totalQuestion2
    }
}



