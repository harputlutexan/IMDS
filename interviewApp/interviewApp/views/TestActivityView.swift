import SwiftUI

struct TestActivityView: View {
    
    let classic_black = Color(hex: 0x000000)
    let classic_white = Color(hex: 0xFFFFFF)
    let lightGrayColor = Color(hex: 0xFAFAFA)
    let grayColor = Color(hex: 0xEEEEEE)
    @StateObject var viewModel = TestActivityViewModel()
    var dataManager = DataManager()
    @Environment(\.presentationMode) var presentationMode
    var testDate: String = ""
    
    //  the order of features are very important for example first frame will be determined
    // than background color than corner radius
    var body: some View {
        NavigationView {
            ZStack{
                Color.gray.opacity(0.1)
            VStack {
                HStack {
                    Text("\(PreferenceManager.shared.getExperience())") // actionbar_difficulty_level
                        .foregroundColor(classic_black)
                        .font(.system(size: 16))
                        .padding(.leading, 5)
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                    
                    Spacer()
                    
                    Text("\(viewModel.currentQuestionIndex + 1) / \(PreferenceManager.shared.getExperience().contains("Assessment") ? 10 : 5)")
                        .foregroundColor(Color.blue)
                        .font(.system(size: 16))
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                    Spacer()
                    
                    Image(systemName: "clock")
                    Text("\(viewModel.elapsedTime.toMinutesAndSeconds())")
                        .foregroundColor(classic_black)
                        .font(.system(size: 16))
                        .padding(.trailing, 5)
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
                .padding(.top, 10)

                //.background(Color.gray.opacity(0.1))
                //print("Updated currentQuestionIndex TestActivityView: \(viewModel.currentQuestionIndex)")
                let currentQuestion = viewModel.loadedQuestionAndOptions[viewModel.currentQuestionIndex].questions
                let options = viewModel.loadedQuestionAndOptions[viewModel.currentQuestionIndex].options
                VStack{
                    Text(currentQuestion)
                        .font(.system(size: 22))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, maxHeight: characterCount(for: currentQuestion) < 140 ? 140  : CGFloat(currentQuestion.count))
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(Color.red)
                        .lineLimit(Int.max) // Allow unlimited lines
                        .multilineTextAlignment(.center) // Adjust text alignment as needed
                        .minimumScaleFactor(0.5) // Adjusts the font size down to 50% if needed
                    //.padding(.horizontal, 20)
                    ForEach(options , id: \.self) { option in
                        Button(action: {
                            //   print("TestActivityViewl currentQuestion \(currentQuestion)")
                            viewModel.isTapped.toggle()
                            //  viewModel.timerFromTest = elapsedTime
                            viewModel.stopTimer()
                            viewModel.updateSelectedOption(option)
                            //this is for to wait after selection
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                viewModel.updateQuestionAndOptions()
                                viewModel.elapsedTime = 1
                            }
                        })
                        {Text(option)
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                                .frame(maxWidth: .infinity, maxHeight: characterCount(for: option) < 65 ? 65 : CGFloat(option.count)) // Adjusted maxHeight
                                .lineLimit(Int.max) // Allow unlimited lines
                                .multilineTextAlignment(.center) // Adjust text alignment as needed
                                .minimumScaleFactor(0.5)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(
                                            viewModel.isTapped ?
                                            (option == viewModel.selectedOption ?
                                             viewModel.selectedOptionBackground :
                                                (option == viewModel.loadedQuestionAndOptions[viewModel.currentQuestionIndex].correctAnswers ?
                                                 Color.green :
                                                    Color.white)
                                            ):Color.white)
                                )
                        }
                        //here is for between button space
                        .cornerRadius(8)
                        .disabled( viewModel.isTapped)
                    }
                    // this padding helps for sides and inner
                    .padding(.vertical,10)
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
                NavigationLink(
                    destination: TestDetailView()
                        .navigationBarItems(leading: EmptyView()),
                    isActive: $viewModel.navigateToTestDetailView,
                    label: {
                        EmptyView()
                    }
                    
                )
            }
           // .background(Color.gray.opacity(0.1)) // Make the background a little bit gray
            .onAppear {
                viewModel.startTimer()
                print("TestActivityView onAppear1")
                if viewModel.navigateToTestDetailView {
                    presentationMode.wrappedValue.dismiss()
                    viewModel.resetNavigation()
                }
            }
            .onDisappear {
                print("TestActivityView onDisappear1")
                viewModel.stopTimer() // Stop the timer when the view disappears
            }
        }
        }
        .navigationBarBackButtonHidden(true)
    }
}

extension Int {
    func toMinutesAndSeconds() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// Helper function to get the character count
func characterCount(for text: String) -> Int {
    return text.count
}

