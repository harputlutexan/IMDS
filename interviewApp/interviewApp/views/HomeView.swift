import SwiftUI
// import GoogleMobileAds

struct HomeView: View {
    //@State private var selectedExperienceLevel: ExperienceLevel?
    @State private var navigateToTest = false
    @StateObject var viewModel = HomeViewModel()
    // will be true after questions get ready
    @StateObject var testViewModel = TestActivityViewModel()
    @State var height: CGFloat = 0 //Height of ad
    @State var width: CGFloat = 0 //Width of ad
    @State var noLife: Bool = false
    @State var experienceLevel : String = ""
    @StateObject private var adViewModel = RewardedAdModel()
    //if you are using a simple binding mechanism like in the example. In this case, a @Binding allows you to share the state between views without the need for an ObservableObject. The @Binding creates a two-way connection between the parent and child views.
    
    //ObservableObject becomes useful when you need to notify multiple views about changes in shared data without direct user interaction. It's particularly handy when you have more complex data flows and multiple views need to observe and react to changes.
    @Binding var showTabView: Bool // Binding to shared state
    @State private var isPressed: Bool = false
    
    let dataExperience = DataExperience()
    
    var body: some View {
        //Both NavigationView and Color conform to View, meaning they are views,
        // so as written your NavigationView was overlaid completely over the Color view.
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let safeAreaTopPadding = windowScene?.windows.first?.safeAreaInsets.top ?? 0
        NavigationView {
            // without this alignment it doesnt start from top
            ZStack(alignment: .top) {
                // this covers all
                Color.gray.opacity(0.1)
                ScrollView {
                    VStack{
                        HStack() {
                            HStack {
                                Image(systemName: "clock") // Replace with your heart icon
                                Text(viewModel.elapsedTime)
                                    .foregroundColor(Color.black)
                                    .font(.system(size: 16))
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal, 5)
                            .padding(.vertical, 25)
                            Spacer() // This spacer will fill any available space
                            // Spacer between LinearLayouts
                            HStack{
                                Button(action: {
                                    // Your action here
                                    if adViewModel.isRewardedAdReady && PreferenceManager.shared.getUserLife() < DataContractIOS.maxUserLife {
                                        print("adViewModel clicked")
                                        adViewModel.showRewardedAd()
                                    } else {
                                        print("not ready")
                                    }
                                }) {
                                    HStack {
                                        Text("Watch Ad \n For Life")
                                        //.fontWeight(.bold)
                                            .font(.system(size: 16)) // Set the font size
                                            .fontWeight(.bold) // Make the font bold
                                            .foregroundColor(.white) // Set the text color to white
                                            .shadow(radius: 5) // Add a shadow for depth
                                            .lineLimit(2) // Allows text wrapping up to two lines
                                            .fixedSize(horizontal: false, vertical: true) // Allows the text to grow vertically
                                            .frame(alignment: .center) // Set a fixed width or use maxWidth
                                            .padding(.leading, 10)
                                        // Spacer() // This will push the text to the left and play button to the right
                                        
                                        Image(systemName: "play.fill") // for a filled play button
                                            .foregroundColor(.white) // Set the color of the play icon to white
                                            .padding(.trailing, 10) // Add padding to the right of the icon
                                    }
                                    .frame(height: 46) // Ensure the HStack fills the width and height of the button
                                }
                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)) // Apply the gradient background
                                .cornerRadius(8) // Apply corner radius for rounded corners
                                //  Spacer()
                            }
                            .frame(maxWidth: .infinity,alignment: .trailing) // Forces this section to take up one-third of the space
                            .padding(.vertical, 10)
                            .padding(.trailing, 10)
                            HStack {
                                Text(String(PreferenceManager.shared.getUserLife()))
                                    .font(.system(size: 24))
                                    .minimumScaleFactor(0.6) // Adjust this value as needed
                                    .lineLimit(1) // Limit the text to a single line
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }
                            .padding(.trailing, 10)
                        }
                        .frame(maxWidth: .infinity) // Forces this section to take up one-third of the space
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.trailing, 20)
                        .padding(.leading, 20)  // Adjust left padding as needed
                        .padding(.top, safeAreaTopPadding/4)

                        VStack {
                            
                            if PreferenceManager.shared.getAllTestsFinished() {
                                Text("Free Mode")
                                    .font(.title)
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                            }else{
                                Text("Assigned Experience")
                                    .font(.title)
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                            }
                            
                            
                            ForEach(ExperienceLevel.allCases, id: \.self) { level in
                                Button(action: {
                                    let experienceManager = PreferenceManager.shared
                                    // experience selecction will be available just for expert level
                                    if experienceManager.getAllTestsFinished() {
                                        //selectExperienceLevel(level.rawValue)
                                        experienceManager.updateExperience(experienceLevel: level.rawValue)
                                        experienceLevel = experienceManager.getExperience()
                                    }else{
                                        // Logic to handle selections when not all tests are finished.
                                        // Assuming getExperience() returns the current level as a String.
                                        let currentLevel = ExperienceLevel(rawValue: experienceManager.getExperience()) ?? .beginner
                                        let selectedLevel = level // The level attempted to be selected.
                                        
                                        if selectedLevel == .beginner || hierarchyValue(for: selectedLevel.rawValue) > hierarchyValue(for: currentLevel.rawValue) {
                                            // Allow selecting "Beginner" or upgrading the level.
                                            experienceManager.updateExperience(experienceLevel: selectedLevel.rawValue)
                                            self.experienceLevel = experienceManager.getExperience()
                                        } else {
                                            // Otherwise, don't change the level; perhaps show a message if needed.
                                            print("Selection not allowed. Current level: \(self.experienceLevel)")
                                        }
                                    }
                                    
                                    // In your code, when you access level.rawValue, it gives you the raw string value
                                    // associated with the ExperienceLevel case, which is a string.
                                    print("a button triggered " + level.rawValue)
                                    print("a button triggered \(experienceLevel)")
                                    print("a button triggered \(PreferenceManager.shared.getAllTestsFinished())")
                                }) {
                                    HStack {
                                        // Image(systemName: iconName(for: level))
                                        // .foregroundColor(.blue) // Set the icon color (optional)
                                        HStack() {
                                            Text(level.rawValue)
                                            //.frame(maxWidth: .infinity)
                                            //.padding() // Add padding around the text
                                                .foregroundColor(determineTextColor(for: level))
                                                .padding(.vertical, 5)
                                            Spacer()
                                            VStack{
                                                CircularProgressView(level: level)
                                                    .padding(.top, 10)
                                                Text("Solved Questions")
                                                    .font(.system(size: 12))
                                            }
                                            .padding(.trailing,10)
                                            .padding(.bottom, 3)
                                            .padding(.top, 3)
                                            
                                            // Spacer()
                                            
                                            
                                            VStack{
                                                CircularProgressForAccuracy(level: level)
                                                    .padding(.top, 10)
                                                Text("True Answers")
                                                //.foregroundColor(Color.black)
                                                    .font(.system(size: 12))
                                            }
                                            .padding(.bottom, 3)
                                            .padding(.top, 3)
                                        }
                                        .padding(.horizontal, 5) // Add padding around the text
                                        // .padding(.leading, 4)
                                    }
                                    // .frame(maxWidth: .infinity, alignment: .leading) // Ensures HStack fills the button and aligns content to the left
                                    .frame(maxWidth: .infinity)
                                }
                                .background(.white)
                                .cornerRadius(8)
                                //.disabled(isButtonDisabled(for: level))
                                .disabled(hierarchyValue(for: level.rawValue) > hierarchyValue(for:  PreferenceManager.shared.getHighestLevelAchieved()))
                                
                            }
                            .cornerRadius(8)
                            // this padding is for between button distances
                            .padding(.vertical, 5)
                            .opacity(10) // Use opacity to hide the button
                            
                            Button(action: {
                                print("start button clicked")
                                if PreferenceManager.shared.getUserLife() > 0 {
                                    noLife = false
                                    let oldLife = PreferenceManager.shared.getUserLife()
                                    PreferenceManager.shared.updateUserLife(userLife: (oldLife-1))
                                    //to differ nvaigate to testdetail or to home
                                    testViewModel.navigateToTestFromHome = true
                                    showTabView = false
                                }else{
                                    noLife = true
                                }
                            }) {
                                Text("Start \(PreferenceManager.shared.getExperience().contains("Assessment") ? experienceLevel : "")")
                                    .font(.system(size: 22))
                                    .fontWeight(.bold) // Make the font bold
                                    .foregroundColor(.white) // Set the text color to white
                                    .shadow(radius: 5) // Add a shadow for depth
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 45)
                                    .lineLimit(Int.max) // Allow unlimited lines
                                    .multilineTextAlignment(.center) // Adjust text alignment as needed
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)) // Gradient background
                                    .cornerRadius(10) // Rounded corners
                                    .shadow(radius: 10) // Add a shadow for depth
                                    .frame(maxWidth: .infinity) // Ensure the Text fills the button's content are
                            }
                            .padding(.top, 10)
                        }
                        .padding(.trailing, 20)
                        .padding(.leading, 20)  // Adjust left padding as needed
                        NavigationLink(destination: TestActivityView(), isActive: $testViewModel.navigateToTestFromHome) {
                            EmptyView()
                        }
                        .alert(isPresented: $noLife) {
                            Alert(
                                title: Text("No Life"),
                                message: Text("No Life Please Watch "),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    .onAppear(){
                        // Reset the flag when coming back to the HomeView
                        showTabView = true
                        let experienceManager = PreferenceManager.shared
                        self.experienceLevel = experienceManager.getExperience()
                        //selectExperienceLevel(experienceLevel)
                        print("HomeView experienceLevel \(experienceLevel)")
                        //print("HomeView selected  \(String(describing: selectedExperienceLevel))")
                        //GADMobileAds.sharedInstance().start()
                        viewModel.initCountdownTimer()
                    }
                    .onDisappear {
                        // Stop the timer when the view disappears
                        viewModel.stopTimer()
                    }
                }
            }        .padding(.bottom,10)

        }
        
    }
    
    func determineTextColor(for level: ExperienceLevel) -> Color {
        let experienceManager = PreferenceManager.shared
        if (experienceManager.getAllTestsFinished() && experienceLevel != level.rawValue) ||
            (!experienceManager.getAllTestsFinished() && experienceLevel != level.rawValue) {
            if hierarchyValue(for: level.rawValue) > hierarchyValue(for:  experienceManager.getHighestLevelAchieved()) {
                return Color.black.opacity(0.4)
            }
            return Color.black
        } else {
            return Color.red
        }
    }
    
    func hierarchyValue(for level: String) -> Int {
        switch level {
        case DataContractIOS.EXPERIENCE_BEGINNER_STRING:
            return 1
        case DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING:
            return 2
        case DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING:
            return 3
        case DataContractIOS.EXPERIENCE_ADVANCED_STRING:
            return 4
        case DataContractIOS.EXPERIENCE_EXPERT_STRING:
            return 5
        default:
            return 0 // Default or unknown value
        }
    }
    
    func shouldDisableButton(for level: String, selectedExperienceLevel: String) -> Bool {
        let selectedLevelValue = hierarchyValue(for: selectedExperienceLevel)
        let levelValue = hierarchyValue(for: level)
        
        // Enable (return false for disabling) the button if its level value is
        // less than or equal to the selected level's value.
        return levelValue > selectedLevelValue
    }
    
    func isButtonDisabled(for level: ExperienceLevel) -> Bool {
        let experienceManager = PreferenceManager.shared
        
        if experienceManager.getAllTestsFinished(){
            return experienceLevel == level.rawValue
        } else{
            return experienceLevel != level.rawValue
        }
        
    }
    
    // Helper function to select an icon name based on the experience level
    func iconName(for level: ExperienceLevel) -> String {
        switch level {
        case .beginner:
            return "star" // Example icon for beginner
        case .intermediate:
            return "star.fill" // Example icon for intermediate
        case .upperIntermediate:
            return "star.circle" // Example icon for expert
        case .advanced:
            return "star.circle.fill" // Example icon for intermediate
        case .expert:
            return "star.square.on.square.fill" // Example icon for expert
            
        }
    }
}

struct CircularProgressView: View {
    let dataExperience = DataExperience()
    var level: ExperienceLevel
    // Assuming functions to get solved and total questions for a level
    var solvedQuestions: Int {
        dataExperience.getSolvedQuestions(experienceLevel: level.rawValue)
    }
    
    var totalQuestions: Int {
        dataExperience.getAllCsvQuestionNumber(experience: level.rawValue) - 1
    }
    
    var body: some View {
        let solvedPercentage = Double(solvedQuestions) / Double(totalQuestions)
        ZStack {
            Circle()
                .stroke(lineWidth: 4.0)
                .opacity(0.4)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(solvedPercentage, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            Text(String(format: "%.0f%%", solvedPercentage * 100))
                .font(.caption)
                .bold()
        }
        .frame(width: 40, height: 40)
    }
}

struct CircularProgressForAccuracy: View {
    let dataExperience = DataExperience()
    
    var level: ExperienceLevel
    // Assuming functions to get solved and total questions for a level
    var solvedQuestions: Int {
        dataExperience.getSolvedQuestions(experienceLevel: level.rawValue)
    }
    
    var trueAnswers : Int {
        dataExperience.getExperienceAccuracy(experienceLevel: level.rawValue)
    }
    
    var truePercentage: Double {
        if solvedQuestions != 0 {
            return Double(trueAnswers) / Double(solvedQuestions)
        } else {
            return 0
        }
    }
    
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(lineWidth: 4.0)
                .opacity(0.4)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(truePercentage, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            
            Text(String(format: "%.0f%%", truePercentage * 100))
                .font(.caption)
                .bold()
        }
        .frame(width: 40, height: 40)
    }
}
