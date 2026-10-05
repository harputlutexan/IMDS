import Foundation


class PreferenceManager {
    // Shared instance (singleton) to make it accessible from all classes
    static let shared = PreferenceManager()
    
    // Method to get the current test ID for a specific difficulty level
    func getCurrentTestID(for difficulty: String) -> Int {
        let defaultValue = 1
        let testIdDifficulty = difficulty + DataContractIOS.testIdPreference
        let testIdFromPreference = UserDefaults.standard.integer(forKey: testIdDifficulty)
        let finalValue = (testIdFromPreference != 0) ? testIdFromPreference : defaultValue
        // print ("PreferenceManager testId finalValue \(finalValue)")
        return finalValue
    }
    
    // Method to update the test ID for a specific difficulty level
    func increaseTestID(for difficulty: String) {
        let testIdDifficulty = difficulty + DataContractIOS.testIdPreference
        // print ("PreferenceManager testIdDifficulty \(testIdDifficulty)")
        let currentID = getCurrentTestID(for: difficulty)
        // print ("PreferenceManager current test ID \(currentID)")
        UserDefaults.standard.set(currentID + 1, forKey: testIdDifficulty)
    }
    
    // Method to update the test ID for a specific difficulty level
    func clearTestID(for difficulty: String) {
        let testIdDifficulty = difficulty + DataContractIOS.testIdPreference
        UserDefaults.standard.set(1, forKey: testIdDifficulty)
    }
    
    
    // for profile and statistics pager overall testId
    func getCurrentGlobalTestID() -> Int {
        let defaultValue = 1
        let testIdFromPreference = UserDefaults.standard.integer(forKey: DataContractIOS.globalTestIdPreference)
        let globalTestId = (testIdFromPreference != 0) ? testIdFromPreference : defaultValue
        //print ("PreferenceManager testId globalTestId \(globalTestId)")
        return globalTestId
    }
    
    // Method to update the test ID for a specific difficulty level
    func updateGlobalTestID() {
        let currentID = getCurrentGlobalTestID()
        // print ("PreferenceManager testId globalTestId currentID \(currentID)")
        UserDefaults.standard.set(currentID + 1, forKey: DataContractIOS.globalTestIdPreference)
        // print ("PreferenceManager testId globalTestId2 \(UserDefaults.standard.integer(forKey: DataContractIOS.globalTestIdPreference))")
    }
    
    func updateExperience(experienceLevel: String){
        UserDefaults.standard.set(experienceLevel, forKey: DataContractIOS.experienceLevel)
    }
    
    func getExperience() -> String {
        return UserDefaults.standard.string(forKey: DataContractIOS.experienceLevel) ?? DataContractIOS.EXPERIENCE_ASSESSTMENT_STRING1
    }
    
    func updateUserLife(userLife: Int){
        print("PreferenceManager updateUserLife \(userLife)")
        
        UserDefaults.standard.set(userLife, forKey: DataContractIOS.lifeOfPlayerString)
    }
    
    func getUserLife() -> Int {
        let userLife = UserDefaults.standard.integer(forKey: DataContractIOS.lifeOfPlayerString)
        return userLife
    }
    
    func updateAllTestsFinished(allTestsFinished: Bool){
        UserDefaults.standard.set(allTestsFinished, forKey: DataContractIOS.EXPERIENCE_ALL_LEVELS_FINISHED_KEY)
    }
    
    func getAllTestsFinished() -> Bool {
        return UserDefaults.standard.value(forKey: DataContractIOS.EXPERIENCE_ALL_LEVELS_FINISHED_KEY) as? Bool ?? false
    }
    
    func updateCounterForEachUsage(counterForEachUsage: Double){
        UserDefaults.standard.set(counterForEachUsage, forKey: DataContractIOS.counterForEachUsage)
    }
    
    func getCounterForEachUsage() -> Double {
        
        return UserDefaults.standard.double(forKey: DataContractIOS.counterForEachUsage)
    }
    func updateStartTime(startTime: Double){
        UserDefaults.standard.set(startTime, forKey: DataContractIOS.startTime)
    }
    
    func getstartTime() -> Double {
        let defaultValue = DataContractIOS.timeForNewLifeSeconds
        let startTimepreference = UserDefaults.standard.double(forKey: DataContractIOS.startTime)
        let finalValue = (startTimepreference != 0) ? startTimepreference : defaultValue
        return finalValue
    }
    
    func updateTimeDifference(timeDifferenceBetweenOldandNew: Double){
        UserDefaults.standard.set(timeDifferenceBetweenOldandNew, forKey: DataContractIOS.timeDifferenceBetweenOldandNewString)
    }
    
    func getTimeDifference() -> Double {
        
        return UserDefaults.standard.double(forKey: DataContractIOS.timeDifferenceBetweenOldandNewString)
    }
    
    func updatePreviousCountDownTime(time: Double){
        UserDefaults.standard.set(time, forKey: DataContractIOS.previousDownTimePreference)
    }
    
    func getPreviousCountDownTime() -> Double {
        
        return UserDefaults.standard.double(forKey: DataContractIOS.previousDownTimePreference)
    }
    
    //check if first installation
    func updateIsFirstOpening(isFirstOpening: Bool){
        UserDefaults.standard.set(isFirstOpening, forKey: DataContractIOS.isFirstInstallationKey)
    }
    
    func getIsFirstOpening() -> Bool {
        return UserDefaults.standard.value(forKey: DataContractIOS.isFirstInstallationKey) as? Bool ?? true
    }
    
    
    func updateScore(currentExperience: String){
        var currentScore = getScore()
        
        switch currentExperience {
        case DataContractIOS.EXPERIENCE_BEGINNER_STRING:
            currentScore += DataContractIOS.EXPERIENCE_BEGINNER_SCORE
        case DataContractIOS.EXPERIENCE_INTERMEDIATE_STRING:
            currentScore += DataContractIOS.EXPERIENCE_INTERMEDIATE_SCORE
        case DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_STRING:
            currentScore += DataContractIOS.EXPERIENCE_UPPER_INTERMEDIATE_SCORE
        case DataContractIOS.EXPERIENCE_ADVANCED_STRING:
            currentScore += DataContractIOS.EXPERIENCE_ADVANCED_SCORE
        case DataContractIOS.EXPERIENCE_EXPERT_STRING:
            currentScore += DataContractIOS.EXPERIENCE_EXPERT_SCORE
        default:
            // Handle unknown experience levels
            break
        }
        
        // Update the score in your preference or storage
        UserDefaults.standard.set(currentScore, forKey: DataContractIOS.EXPERIENCE_SCORE_PREFERENCE)
        
    }
    
    func getScore() -> Int{
//        let defaultValue = DataContractIOS.EXPERIENCE_BEGINNER_SCORE
//        var currentScore = UserDefaults.standard.integer(forKey: DataContractIOS.EXPERIENCE_SCORE_PREFERENCE)
//        let finalValue = currentScore == 0 ? defaultValue : currentScore
        return UserDefaults.standard.integer(forKey: DataContractIOS.EXPERIENCE_SCORE_PREFERENCE)
    }
    
       
    func setAchievementDate (currentDate: String, achievementKey: String){
        UserDefaults.standard.set(currentDate, forKey: achievementKey)
    }
    
    func getAchievementDate(achievementKey: String) -> String {
        return UserDefaults.standard.value(forKey: achievementKey) as? String ?? ""
    }
    
    func setAchievementCompletion (completed: Bool, achievementKey: String){
        UserDefaults.standard.set(completed, forKey: achievementKey)
    }
    
    func getAchievementCompletion(achievementKey: String) -> Bool {
        return UserDefaults.standard.value(forKey: achievementKey) as? Bool ?? false
    }
    
    
    func updateHighestLevelAchieved(newLevel: String) {
        // Logic to update highestLevelAchieved if newLevel is higher
        // This assumes you can convert levels to a comparable value (e.g., using hierarchyValue method)
        let highestLevel = getHighestLevelAchieved()
        if hierarchyValue(for: newLevel) > hierarchyValue(for: highestLevel) {
            UserDefaults.standard.set(newLevel, forKey: DataContractIOS.highestLevelAchievedPreference)
        }
    }
    
    func getHighestLevelAchieved() -> String {
        return UserDefaults.standard.value(forKey: DataContractIOS.highestLevelAchievedPreference) as? String ?? "Beginner"
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
    
}
