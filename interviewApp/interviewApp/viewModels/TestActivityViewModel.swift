
import Foundation
import SwiftUI


// options can be considered as 2d array, each structure element is array
struct QuestionStructure {
    let questions: String
    let correctAnswers: String
    let options: [String]
    let answerExplanation: String
}



class TestActivityViewModel: ObservableObject {
    // test ID will be increased at CSVmanager after appendint temp and new file
    @Published var currentQuestionIndex: Int = 0
    @Published var navigateToTestDetailView : Bool = false
    @Published var accuracy: Bool = false // Initialize with a default value
    @Published var selectedOptionBackground: Color = .white
    @Published var correctOptionBackground: Color = .blue
    @Published var isTapped = false
    // @Published var timerFromTest = 0
    @Published var navigateToTestFromHome : Bool = false
    // to enable tab movements
    @Published var timer: Timer?
    @Published var elapsedTime: Int = 0
    @State private var isTimerRunning = false
    @AppStorage(DataContractIOS.testDetaiIdPreference) private var tappedItemIndex: Int = 0

    
    
    var loadedQuestionAndOptions: [QuestionStructure] = []
    var selectedOption : String = ""
    var resultAccuracy : Bool = false
    
    init() {
        loadQuestionOptionSets()
        
        if navigateToTestFromHome{
            navigateToTestDetailView = true;
        }
    }
    
    // Timer update function
    private func updateTimer() {
        elapsedTime += 1
    }
    
    // Start the timer when the view appears
    public func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateTimer()
        }
    }
    
    // Stop the timer when the view disappears
    public func stopTimer() {
        //print("TestActivityViewModel stopTimer")
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    
    // to show test details instead of testview again
    func resetNavigation() {
        print("TestActivityViewModel resetNavigation called")
        navigateToTestFromHome = false
    }
    
    // after selection an option
    func updateQuestionAndOptions() {
        if !isTimerRunning {
           // print("TestActivityViewModel !isTimerRunning")
            startTimer()
            isTimerRunning = true
        }
        //print("currentQuestionIndex (before increment)TestActivityViewModel: \(currentQuestionIndex)")
        self.accuracy = resultAccuracy
        //print("TestActivityViewModel loadedQuestionAndOptions: \(loadedQuestionAndOptions.count)")
        writeToCsvTempFile()
        if currentQuestionIndex < loadedQuestionAndOptions.count-1 {
            isTapped = false
            currentQuestionIndex += 1
            
            // print("currentQuestionIndex (after increment): \(currentQuestionIndex)")
            // after test finishes
        } else {
            print("TestActivityViewModel updateQuestionAndOptions called")
            let preferenceManager = PreferenceManager.shared
            let currentExperience = preferenceManager.getExperience()
            preferenceManager.updateScore(currentExperience: currentExperience)
            writeAndAppendCsvFiles()
            tappedItemIndex = preferenceManager.getCurrentGlobalTestID()
            preferenceManager.increaseTestID(for: currentExperience)
            preferenceManager.updateGlobalTestID()
            let dataExperienceClass = DataExperience()
            dataExperienceClass.updateTestLevel()
            
            resetNavigation()
            navigateToTestDetailView = true
            isTapped = false
            // after test finish
            
            
        }
    }
    
    // check all solved questions and get accuracy ratios
    
    
    
    func writeAndAppendCsvFiles(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let csvNewFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
        let csvNewManager = CSVManager(filePath: csvNewFilePath)
        let csvTempFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.tempCSVFileName).path
        csvNewManager.appendCSVFiles(sourcePath: csvTempFilePath, destinationPath: csvNewFilePath)
        //let csvTempFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.tempCSVFileName).path
        let csvTempManager = CSVManager(filePath: csvTempFilePath)
        csvTempManager.clearCSVFile(filePath: csvTempFilePath)
    }
    
    
    func writeToCsvTempFile(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let csvTempFilePath = documentsDirectory.appendingPathComponent(DataContractIOS.tempCSVFileName).path
        let csvTempManager = CSVManager(filePath: csvTempFilePath)
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentLocale = Locale.current
        dateFormatter.locale = currentLocale
        let testDate = dateFormatter.string(from: currentDate)
        let currentQuestion = loadedQuestionAndOptions[currentQuestionIndex].questions
        let options = loadedQuestionAndOptions[currentQuestionIndex].options
        let correctAnswer = loadedQuestionAndOptions[currentQuestionIndex].correctAnswers
        let chatGPTExplanation = loadedQuestionAndOptions[currentQuestionIndex].answerExplanation
        let experienceManager = PreferenceManager.shared
        let experienceLevel = experienceManager.getExperience()
        let testId = experienceManager.getCurrentGlobalTestID()
        let timerFromTest = elapsedTime
        // here data is saved to CSV temp file using CSVManager
        //print("TestActivityViewModel timerFromTest \(timerFromTest)")
        let data: [Any] = [experienceLevel, Int64(testId), testDate, currentQuestion, selectedOption, correctAnswer, String(resultAccuracy), timerFromTest, options[0], options[1], options[2], options[3], chatGPTExplanation]
        csvTempManager.appendTestData(data)
    }
    
    // in options array first element will be correct option others will get by order
    // but here depending on assessment or experience level questions will be requested
    func loadQuestionOptionSets() {
        if navigateToTestFromHome{
            navigateToTestDetailView = true;
        }
        
        var questionSet : [[String]] = []
        let currentExperience = PreferenceManager.shared.getExperience()
        print("TestActivityViewModel loadQuestionOptionSets currentExperience, \(currentExperience)")
        // after all tests experience levels will be checked and updated
        questionSet = DataExperience().getCvsQuestionSets(experience: currentExperience)
        questionSet = questionSet.filter { !($0.count == 1 && $0.first == "") }

        //print("TestActivityViewModel questionSet, \(questionSet)")
        
       // print("TestActivityViewModel questionSet.count , \(questionSet.count )")
        
        if questionSet.count > 1 {
            for i in 0..<questionSet.count {
                
                let questionIndex = questionSet[i].startIndex
                let questionText = String(questionSet[i][questionIndex])
                //print("TestActivityViewModel questionText \(questionText)")
                
                // Convert String to Array of Characters and then back to String
                let options = Array(questionSet[i][2...5])
                let correctAnswer = questionSet[i][1]
                let chatGPTExplanation = questionSet[i][7]
                // Shuffle the options
                let shuffledOptions = Array(options.shuffled())
                //    print("shuffledOptions, \(shuffledOptions)!")
                // question Object is being created
                let question = QuestionStructure(questions: questionText, correctAnswers: correctAnswer
                                                 , options: shuffledOptions, answerExplanation: chatGPTExplanation)
                loadedQuestionAndOptions.append(question)
                // Update the currentQuestion
                //currentQuestion = question
            }
        }
        // print("TestActivityViewModel loadedQuestionAndOptions \(loadedQuestionAndOptions)")
        // print("Current Index: \(currentQuestionIndex)")
        // print("Questions Count: \(loadedQuestionAndOptions.count)")
    }
    

    
    func updateSelectedOption(_ option: String) {
        let correctAnswer = loadedQuestionAndOptions[currentQuestionIndex].correctAnswers
        selectedOption = option
        resultAccuracy = selectedOption == correctAnswer
        //print("resultAccuracy \(resultAccuracy)")
        //        print("option \(selectedOption)")
        //        print("isTapped \(isTapped)")
        //        print("correctAnswer \(correctAnswer)")
        
        // Update the background color based on selection and correctness
        //       let isCorrect = option == correctAnswer
        
        selectedOptionBackground = resultAccuracy ? Color.green : Color.red
        correctOptionBackground = resultAccuracy ? Color.green : Color.red // Change color for correct option
        
        
        // Update the accuracy property in the view model
        accuracy = resultAccuracy
    }
    
}

