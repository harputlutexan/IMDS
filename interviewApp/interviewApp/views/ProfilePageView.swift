import SwiftUI
import MessageUI
import GameKit


struct ProfilePageView: View {
    @StateObject var viewModel = ProfilePageModel()
    @StateObject var emailManager = EmailManager() // Create an instance of EmailManager
    @State private var showMailComposer = false
    @State private var showAlert = false
    @State private var isGameCenterAuthenticated = false
    @State private var showingLeaderboard = false
    @State private var profileImage: Image? = nil
    @State  var showingPopup: Bool = false
    @State  var analysedResponse: String = ""
    @State  var analyseIsLoading = false
    @Binding var showTabView: Bool // Binding to shared state
    @State var notEnoughQuestionSolvedYet: Bool = false
    
    
    var body: some View {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let safeAreaTopPadding = windowScene?.windows.first?.safeAreaInsets.top ?? 0
        ZStack(alignment: .top) {
            //.background(Color.gray.opacity(0.1)) // Make the background a little bit gray
            Color.gray.opacity(0.1)
            ScrollView{
                VStack {
                    HStack{
                        HStack{
                            if let profileImage = profileImage {
                                profileImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                            } else {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.leading, 20)
                        Spacer()
                        
                        HStack{
                            Button(action: {
                                showingLeaderboard = true
                            }) {
                                HStack {
                                    Image(systemName: "gamecontroller.fill")
                                        .font(.title) // Adjust the size as needed
                                    Text("Game Center")
                                        .fontWeight(.semibold) // Add some weight to the text
                                }
                                .padding(.vertical, 10) // Adjust vertical padding to control height
                                .padding(.horizontal) // Horizontal padding for width
                                .foregroundColor(.white) // Set the text color to white
                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)) // Gradient background
                                .cornerRadius(10) // Rounded corners
                                .shadow(radius: 5) // Add a shadow for depth
                            }
                            .frame(height: 50) // Explicitly set the height of the button to control size
                            .padding(.trailing, 20) // Adjust padding to align with the profile photo's leading edge
                        }
                        //  .frame(maxWidth: .infinity) // Ensure HStack takes full width for proper spacing
                        
                    }
                    .frame(maxWidth: .infinity) // Forces this section to take up one-third of the space
                    .padding(.trailing, 20)
                    .padding(.leading, 20)  // Adjust left padding as needed
                    .padding(.top, safeAreaTopPadding/4)
                    .padding(.bottom, safeAreaTopPadding/4)
                    
                    HStack {
                        VStack{
                            Text("Total")
                            //  .font(.headline)
                                .foregroundColor(.black)
                            Text("Test Solved")
                            //  .font(.headline)
                                .foregroundColor(.black)
                            Text("\(String(viewModel.totalTest))")
                                .foregroundColor(.gray)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20 )
                        Spacer()
                        VStack{
                            Text("Total")
                            //  .font(.headline)
                                .foregroundColor(.black)
                            Text("Questions Solved")
                            //  .font(.headline)
                                .foregroundColor(.black)
                            Text("\(String(viewModel.totalQuestionSolved))")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 20 )
                    }
                    .padding(.vertical, 5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    
                    HStack {
                        VStack{
                            Text("Total")
                            //  .font(.headline)
                                .foregroundColor(.black)
                            Text("True Answers")
                            //  .font(.headline)
                                .foregroundColor(.black)
                            Text("\(String(viewModel.totalCorrectResult))")
                                .foregroundColor(.gray)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20 )
                        Spacer()
                        VStack{
                            Text("Total")
                            //  .font(.headline)
                                .foregroundColor(.black)
                            Text("Wrong Answers")
                            //  .font(.headline)
                                .foregroundColor(.black)
                            Text("\(String(viewModel.totalQuestionSolved-viewModel.totalCorrectResult))")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 20 )
                    }
                    .padding(.vertical, 5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    
                    HStack {
                        VStack{
                            Text("Total")
                            //  .font(.headline)
                                .foregroundColor(.black)
                            Text("Answer Times")
                            //  .font(.headline)
                                .foregroundColor(.black)
                            Text("\(viewModel.totalSumOfTimes)")
                                .foregroundColor(.gray)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20 )
                        Spacer()
                        VStack{
                            Text("Average")
                            //  .font(.headline)
                                .foregroundColor(.black)
                            Text("Answer Time")
                            //  .font(.headline)
                                .foregroundColor(.black)
                            Text("\(String(viewModel.averageTime)) sec.")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 20 )
                    }
                    .padding(.vertical, 5)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    
                    HStack {
                        Text("Score")
                        // .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text(String(PreferenceManager.shared.getScore()))
                        // .font(.headline)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(20)
                    // Add internal padding as needed
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    
                    Button(action: {
                        let solvedQuestion = viewModel.getSolvedQuestions()
                        if  solvedQuestion >= 5 {
                            notEnoughQuestionSolvedYet = false
                            self.showTabView.toggle()
                            analyseIsLoading = true // Start loading
                            viewModel.analyzeProgressViaChatGPT { responseString in
                                DispatchQueue.main.async { // Ensure UI updates are on the main thread
                                    self.analysedResponse = responseString!
                                    self.showingPopup = true
                                    analyseIsLoading = false // Stop loading after response is received
                                    self.showTabView.toggle()
                                }
                            }
                        } else{
                            notEnoughQuestionSolvedYet = true
                        }
                        
                    }) {
                        Text("Analyze Progress")
                            .fontWeight(.semibold) // Add some weight to the text
                            .padding(.vertical, 10) // Adjust vertical padding to control height
                            .padding(.horizontal) // Horizontal padding for width
                            .foregroundColor(.white) // Set the text color to white
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)) // Gradient background
                            .cornerRadius(10) // Rounded corners
                            .shadow(radius: 5) // Add a shadow for depth
                        
                        if analyseIsLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(2.5) // Optional: Adjust the size of the ProgressView
                                .offset(y: 40) // Adjust this value to move the progress view lower
                        }
                        
                    }
                    .frame(height: 50) // Explicitly set the height of the button to control size
                    .padding(.trailing, 20) // Adjust padding to align with the profile photo's leading edge
                    .disabled(analyseIsLoading) // Disable the button when loading
                    Spacer()
                        .sheet(isPresented: $showingLeaderboard) {
                            GameCenterLeaderboardView()
                        }
                        .sheet(isPresented: $showingPopup) { // Present the pop-up
                            // The content of the pop-up
                            AnalysePopupView(showingPopup: $showingPopup, analysedResponse: $analysedResponse)
                        }
                
                }
                .alert(isPresented: $notEnoughQuestionSolvedYet) {
                    Alert(
                        title: Text("PLease Solve More Question"),
                        message: Text("Not Enough False Question to Analyse Progress"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .onAppear {
                    viewModel.updateValues()
                    authenticateGameCenterPlayer()
                    loadGameCenterProfilePhoto()
                    submitScoreToLeaderboard()
                }
            }
        }
        // this padding helps to avoid overlapping with tab
        .padding(.bottom,10)
        //.padding(.top,10)
       
    }
    
    func authenticateGameCenterPlayer() {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // If a viewController is presented, show it. This is needed for the login process.
                // Since SwiftUI does not directly handle UIKit view controllers, you might need to wrap this in a SwiftUI view.
            } else if localPlayer.isAuthenticated {
                // Player is authenticated.
                self.isGameCenterAuthenticated = true
            } else {
                // Error handling
                print("Error authenticating Game Center Player: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func loadGameCenterProfilePhoto() {
        GKLocalPlayer.local.loadPhoto(for: .normal) { (uiImage, error) in
            guard let uiImage = uiImage, error == nil else {
                print("Error loading Game Center profile photo: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.profileImage = Image(uiImage: uiImage)
        }
    }
    
    
}

struct AnalysePopupView: View {
    @Binding var showingPopup: Bool
    @Binding var analysedResponse: String
    
    
    var body: some View {
        ZStack {
            Color.white // Background color of the popup
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 12) {
                Button(action: {
                    self.showingPopup = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title)
                        .padding(.all, 20)
                }
                .alignmentGuide(.leading) { d in d[.leading] }
                .padding(.bottom, 20)
                
                Text("AI Analyse of Current Progress")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 10)
                
                JustifiedTextView(text: analysedResponse)
                    .font(.body)
                    .font(.system(size: 14))
                    .padding(.bottom, 5)
                
                Spacer()
            }
            .padding()
            .background(Color.white) // Optional: Change to a different color or add a gradient
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
        }}
}


struct AnalyseJustifiedTextView: UIViewRepresentable {
    var text: String
    var font: UIFont = .systemFont(ofSize: 14) // Default font, can be customized
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = true // Allow scrolling
        textView.isEditable = false // Make textView non-editable
        textView.isUserInteractionEnabled = true // Allow user interaction like scrolling
        textView.textAlignment = .justified
        textView.textContainer.lineFragmentPadding = 0 // Remove padding on the left and right
        textView.textContainerInset = .zero // Remove padding on the top and bottom
        textView.font = font // Set font here if needed
        textView.backgroundColor = .clear // Transparent background
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = font // Ensure the font is applied during update
    }
}

func submitScoreToLeaderboard() {
    let score = PreferenceManager.shared.getScore()
    let leaderboardID = "DailyDataScienceQuizLeaderboardID2306"
    guard GKLocalPlayer.local.isAuthenticated else {
        print("Player is not authenticated")
        return
    }
    
    // Prepare the score submission
    GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID]) { error in
        if let error = error {
            print("Error submitting score: \(error.localizedDescription)")
        } else {
            print("Score submitted successfully")
        }
    }
}



struct GameCenterLeaderboardView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GKGameCenterViewController {
        let viewController = GKGameCenterViewController(state: .leaderboards)
        viewController.gameCenterDelegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GKGameCenterControllerDelegate {
        var parent: GameCenterLeaderboardView
        
        init(_ parent: GameCenterLeaderboardView) {
            self.parent = parent
        }
        
        func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
            gameCenterViewController.dismiss(animated: true)
        }
    }
}

