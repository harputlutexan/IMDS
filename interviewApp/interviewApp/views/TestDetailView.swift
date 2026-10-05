//
//  interviewApp
//
//  Created by Omer Usluogullari on 9.11.2023.
//
import SwiftUI
import UIKit

// this is for statistic page, only difference this will receive test ID from statitstic page listview
struct TestDetailView: View {//@ObservedObject var dataManager: DataManager
    @State private var goToStatisticPage = false // Track navigation within the view
    @StateObject var detailViewModel = TestDetailModel()
    @AppStorage(DataContractIOS.testDetaiIdPreference) private var tappedItemIndex: Int = 0
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var goToHome = false // Track navigation within the view
    @State private var showTabView = true // Shared state
    @State private var showingPopup = false // 1. State variable for managing pop-up visibility
    @State private var selectedAnswer = "" // To store the correct answer for display in the pop-up
    @State private var detailedAnswer: String = ""
    @State private var detailedAnswerQuestion: String = ""
    @State private var isPressed: Bool = false
    
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
            ScrollView{
                VStack {
                    Text("Quiz Review")
                        .font(.system(size: 22)) // Set the font size
                        .fontWeight(.bold) // Make the font bold
                        .foregroundColor(.black) // Set the text color to white
                    
                    Text("Click Correct Answer for Detailed AI Explanation")
                        .font(.system(size: 18)) // Set the font size
                        .foregroundColor(.black) // Set the text color to white
                        .fixedSize(horizontal: false, vertical: true) // Allow text to wrap
                        .multilineTextAlignment(.center) // Adjust text alignment as needed
                    
                    let screenWidth = UIScreen.main.bounds.width
                    let columnWidth = (screenWidth * 0.85) / 3
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: columnWidth, maximum: .infinity), alignment: .top), count: 3), spacing: 5) {

                        Text("Question")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(height: 40)
                        // these paddings are for each text
                            .frame(width: columnWidth)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                        Text("Your Answer")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(height: 40)
                            .frame(width: columnWidth)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                        Text("Correct Answer")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(height: 40)
                            .frame(width: columnWidth)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                    }
                    .padding(.vertical, 10)
                    .padding(.leading,10)
                    .padding(.trailing,10)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: columnWidth, maximum: .infinity), alignment: .top), count: 3), spacing: 10) {
                        ForEach(detailViewModel.updateTestDetails(), id: \.question) { data in
                            Text(data.question)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .frame(width: columnWidth)
                                .frame(height: characterCount(for: data.question) < 100 ? 100 : CGFloat(data.question.count))
                                .lineLimit(Int.max) // Allow unlimited lines
                                .multilineTextAlignment(.center) // Adjust text alignment as needed
                                .minimumScaleFactor(0.5) // Adjusts the font size down to 50% if needed
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                            Text(data.userAnswer)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .frame(width: columnWidth)
                                .frame(height: characterCount(for: data.question) < 100 ? 100 : CGFloat(data.question.count)) // Adjusted maxHeight
                                .lineLimit(Int.max) // Allow unlimited lines
                                .multilineTextAlignment(.center) // Adjust text alignment as needed
                                .minimumScaleFactor(0.5) // Adjusts the font size down to 50% if needed
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white))
                            // 2. Convert Text to Button for correctAnswer
                            Button(action: {
                                self.selectedAnswer = data.correctAnswer // Store the correct answer for later use
                                self.detailedAnswer = data.chatCPTExplanation
                                self.detailedAnswer = detailedAnswer.replacingOccurrences(of: "\\n", with: "\n")
                                self.detailedAnswerQuestion = data.question
                                self.showingPopup = true // Show the pop-up
                            }) {
                                Text(data.correctAnswer)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white) // Changed for better contrast
                                    .padding(.horizontal, 10)
                                    .frame(width: columnWidth)
                                    .frame(height: characterCount(for: data.question) < 100 ? 100 : CGFloat(data.question.count)) // Adjusted maxHeight
                                    .lineLimit(Int.max) // Allow unlimited lines
                                    .multilineTextAlignment(.center) // Adjust text alignment as needed
                                    .minimumScaleFactor(0.5) // Adjusts the font size down to 50% if needed
                                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(data.userAnswer == data.correctAnswer ? Color.green : Color.red))
                                    .shadow(color: .gray, radius: 5, x: 0, y: 2) // Added shadow
                                    .scaleEffect(isPressed ? 1.1 : 1.0) // Scale effect on press
                                    .animation(.easeInOut, value: isPressed)
                            }
                            .simultaneousGesture(LongPressGesture(minimumDuration: 0.1).onChanged { _ in
                                self.isPressed = true
                            }.onEnded { _ in
                                self.isPressed = false
                            })
                            .sheet(isPresented: $showingPopup) { // Present the pop-up
                                // The content of the pop-up
                                PopupView(detailedAnswer: $detailedAnswer, showingPopup: $showingPopup, detailedAnswerQuestion: $detailedAnswerQuestion)
                            }
                            
                        }
                        
                    }
                    .padding(.leading,10)
                    .padding(.trailing,10)
                    if goToStatisticPage{
                        NavigationLink(
                            destination: AllTestStatisticsView(),
                            isActive: $goToStatisticPage,
                            label: {
                                if goToStatisticPage {
                                    Text("Go to AllTestStatisticsView")
                                } else {
                                    EmptyView()
                                }
                            }
                        )
                    } else if goToHome {
                        NavigationLink(
                            destination:HomeView(showTabView: $showTabView),
                            isActive: $goToHome,
                            label: {
                                EmptyView()
                            }
                        ).hidden()
                    }
                }
            }
            }
           // .navigationBarHidden(true)
            .background(Color.gray.opacity(0.1)) // Make the background a little bit gray
        }
        //.padding(UIScreen.main.bounds.width * 0.04)
        //.navigationBarTitle("") // Clear the title to make room for the default back button
        // this is a must to remove top space
        //.edgesIgnoringSafeArea(.all)
        .background(Color.gray.opacity(0.1)) // Make the background a little bit gray
    }
    
}

// Example PopupView
struct PopupView: View {
    @Binding var detailedAnswer: String
    @Binding var showingPopup: Bool
    @Binding var detailedAnswerQuestion: String
    
    
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
                
                Text(detailedAnswerQuestion)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 10)
                    .multilineTextAlignment(.center)
                JustifiedTextView(text: detailedAnswer)
                    //.font(.body)
                    //.font(.system(size: 24))
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


struct JustifiedTextView: UIViewRepresentable {
    var text: String
    var font: UIFont = .systemFont(ofSize: 18) // Default font, can be customized
    
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





