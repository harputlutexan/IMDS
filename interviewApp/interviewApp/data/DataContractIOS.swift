
import Foundation

struct DataContractIOS{
    // there are two type of ID one Global to show at Statistics Page
    // other to follow test regarding to Experience
    
    static let shared = DataContractIOS()

    static let testIdPreference = " testIdPreference"
    static let globalTestIdPreference = "globalTestIdPreference"

    // All types of experience preference KEYs
    static let EXPERIENCE_ASSESSTMENT_STRING1 = "Assessment 1"
    static let EXPERIENCE_ASSESSTMENT_STRING2 = "Assessment 2"
    static let EXPERIENCE_ASSESSTMENT_STRING3 = "Assessment 3"
    static let EXPERIENCE_BEGINNER_STRING = "Beginner"
    static let EXPERIENCE_INTERMEDIATE_STRING = "Intermediate"
    static let EXPERIENCE_UPPER_INTERMEDIATE_STRING = "Upper Intermediate"
    static let EXPERIENCE_ADVANCED_STRING = "Advanced"
    static let EXPERIENCE_EXPERT_STRING = "Expert"
    static let EXPERIENCE_ALL_LEVELS_FINISHED_KEY = "All Levels Finished"
    static let experienceLevel = "experienceLevel"
    
    static let EXPERIENCE_SCORE_PREFERENCE = "Recorded Score"
    static let EXPERIENCE_BEGINNER_SCORE = 5
    static let EXPERIENCE_INTERMEDIATE_SCORE = 10
    static let EXPERIENCE_UPPER_INTERMEDIATE_SCORE = 15
    static let EXPERIENCE_ADVANCED_SCORE = 20
    static let EXPERIENCE_EXPERT_SCORE = 25
    
    static let assessmentQuestionNumbers = 10
    static let regularTestsQuestionNumbers = 5
    // mulitply with question number
    static let assessmentTreshold = 0.7
    // later lets increase it to 24 to pass next level
    static let tresholdSolvedQuestion = 24
    static let levelsTreshold = 0.5

    static let timeDifferenceBetweenOldandNewString = "timeDifferenceBetweenOldandNewOpening"
    static let lifeOfPlayerString = "lifeOfPlayer"
    static let vibrationPreference = "vibrationPreference"
    static let maxUserLife = 5
    static let maxUserLifePreference = "maxUserLifePreference"
    static let timeForNewLifeSeconds: Double = 14400
    static let previousDownTimePreference = "newCountDownTime"
    // time within using app
    static let counterForEachUsage = "counterForEachUsage"
    static let startTime = "startTime"
    
    //static let interstitial_full_screen_summary_activity_trial = "ca-app-pub-3940256099942544/1033173712"
    //static let bannerTestId = "ca-app-pub-3940256099942544/2934735716"
    static let rewardedTestId = "ca-app-pub-7568605238512922/3026931045"
    //test id
    //static let rewardedTestId = "ca-app-pub-3940256099942544/1712485313"



    
    // CSV file columns to save test results
    static let CSVExperienceColumn = 0
    static let CSVtestIdColumn = 1
    static let CSVdateColumn = 2
    static let CSVquestionColumn = 3
    static let CSVselectedOptionColumn = 4
    static let CSVcorrectAnswerOptionColumn = 5
    static let CSVaccuracyColumn = 6
    static let CSVtimeColumn = 7
    static let CSVOptionColumn1 = 8
    static let CSVOptionColumn2 = 9
    static let CSVOptionColumn3 = 10
    static let CSVOptionColumn4 = 11
    static let CSVTestDetailExplanationColum = 12
    static let newCSVFileName = "new_test_results.csv"
    static let tempCSVFileName = "temp_test_results.csv"
    
    static let testDetaiIdPreference = "tappedItemIndex"
    static let isFirstInstallationKey = "isFirstInstallationKey"
    
    static let keyForIsCompletedAchievementBeginner1 = "First Test Finished I."
    static let keyForDateAchievementBeginner1 = "currentDateAchievementBeginner1"
    static let keyForIsCompletedAchievementBeginner2 = "Make 20 Answers Correct I."
    static let keyForDateAchievementBeginner2 = "currentDateAchievementBeginner2"
    static let keyForIsCompletedAchievementBeginner3 = "Have 70% Correct Answer I."
    static let keyForDateAchievementBeginner3 = "currentDateAchievementBeginner3"

    static let keyForIsCompletedAchievementIntermediate1 = "First Test Finished II."
    static let keyForDateAchievementIntermediate1 = "currentDateAchievementIntermediate1"
    static let keyForIsCompletedAchievementIntermediate2 = "Make 20 Answers Correct II."
    static let keyForDateAchievementIntermediate2 = "currentDateAchievementIntermediate2"
    static let keyForIsCompletedAchievementIntermediate3 = "Have 70% Correct Answer II."
    static let keyForDateAchievementIntermediate3 = "currentDateAchievementIntermediate3"
    
    static let keyForIsCompletedAchievementUpperIntermediate1 = "First Test Finished III."
    static let keyForDateAchievementUpperIntermediate1 = "currentDateAchievementUpperIntermediate1"
    static let keyForIsCompletedAchievementUpperIntermediate2 = "Make 20 Answers Correct III."
    static let keyForDateAchievementUpperIntermediate2 = "currentDateAchievementUpperIntermediate2"
    static let keyForIsCompletedAchievementUpperIntermediate3 = "Have 70% Correct Answer III."
    static let keyForDateAchievementUpperIntermediate3 = "currentDateAchievementUpperIntermediate3"
    
    static let keyForIsCompletedAchievementAdvanced1 = "First Test Finished IV."
    static let keyForDateAchievementAdvanced1 = "currentDateAchievementAdvanced1"
    static let keyForIsCompletedAchievementAdvanced2 = "Make 20 Answers Correct IV."
    static let keyForDateAchievementAdvanced2 = "currentDateAchievementAdvanced2"
    static let keyForIsCompletedAchievementAdvanced3 = "Have 70% Correct Answer IV."
    static let keyForDateAchievementAdvanced3 = "currentDateAchievementAdvanced3"
    
    static let keyForIsCompletedAchievementExpert1 = "First Test Finished V."
    static let keyForDateAchievementExpert1 = "currentDateAchievementExpert1"
    static let keyForIsCompletedAchievementExpert2 = "Make 20 Answers Correct V."
    static let keyForDateAchievementExpert2 = "currentDateAchievementExpert2"
    static let keyForIsCompletedAchievementExpert3 = "Have 70% Correct Answer V."
    static let keyForDateAchievementExpert3 = "currentDateAchievementExpert3"
    
    static let chatGPTQuestion = "I am an engineer preparing for a data science interview application, and following are questions I answered wrong, dont address each question Can you summerize mistakes and suggest me some material or website or youtube channel to improve myself."

    static let highestLevelAchievedPreference = "highestLevelAchieved"
    
}

