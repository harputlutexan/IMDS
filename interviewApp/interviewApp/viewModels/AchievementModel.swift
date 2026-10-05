//
//  AchievementModel.swift
//  interviewApp
//
//  Created by Omer Usluogullari on 15.03.2024.
//

import Foundation

class AchievementModel: ObservableObject {
    
    @Published var achievements: [Achievement]


    init() {
        self.achievements = []
        loadData()
    }
    
    func loadData() {
        let preferenceManager = PreferenceManager.shared
        // print("beg1 \(preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementBeginner1))")
        // print("beg2 \(preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementIntermediate1))")
        // print("beg3 \(preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementUpperIntermediate1))")

        self.achievements = [
            Achievement(title: "Beginner 1",
            description: DataContractIOS.keyForIsCompletedAchievementBeginner1,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementBeginner1),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementBeginner1)),
            Achievement(title: "Beginner 2",
            description: DataContractIOS.keyForIsCompletedAchievementBeginner2,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementBeginner2),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementBeginner2)),
            Achievement(title: "Beginner 3",
            description: DataContractIOS.keyForIsCompletedAchievementBeginner3,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementBeginner3),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementBeginner3)),
            Achievement(title: "Intermediate 1",
            description: DataContractIOS.keyForIsCompletedAchievementIntermediate1,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementIntermediate1),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementIntermediate1)),
            Achievement(title: "Intermediate 2",
            description: DataContractIOS.keyForIsCompletedAchievementIntermediate2,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementIntermediate2),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementIntermediate2)),
            Achievement(title: "Intermediate 3",
            description: DataContractIOS.keyForIsCompletedAchievementIntermediate3,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementIntermediate3),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementIntermediate3)),
            Achievement(title: "Upper Intermediate 1",
            description: DataContractIOS.keyForIsCompletedAchievementUpperIntermediate1,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementUpperIntermediate1),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementUpperIntermediate1)),
            Achievement(title: "Upper Intermediate 2",
            description: DataContractIOS.keyForIsCompletedAchievementUpperIntermediate2,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementUpperIntermediate2),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementUpperIntermediate2)),
            Achievement(title: "Upper Intermediate 3",
            description: DataContractIOS.keyForIsCompletedAchievementUpperIntermediate3,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementUpperIntermediate3),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementUpperIntermediate3)),
            Achievement(title: "Advanced 1",
            description: DataContractIOS.keyForIsCompletedAchievementAdvanced1,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementAdvanced1),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementAdvanced1)),
            Achievement(title: "Advanced 2",
            description: DataContractIOS.keyForIsCompletedAchievementAdvanced2,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementAdvanced2),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementAdvanced2)),
            Achievement(title: "Advanced 3",
            description: DataContractIOS.keyForIsCompletedAchievementAdvanced3,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementAdvanced3),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementAdvanced3)),
            Achievement(title: "Expert 1",
            description: DataContractIOS.keyForIsCompletedAchievementExpert1,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementExpert1),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementExpert1)),
            Achievement(title: "Expert 2",
            description: DataContractIOS.keyForIsCompletedAchievementExpert2,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementExpert2),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementExpert2)),
            Achievement(title: "Expert 3",
            description: DataContractIOS.keyForIsCompletedAchievementExpert3,
            date: preferenceManager.getAchievementDate(achievementKey: DataContractIOS.keyForDateAchievementExpert3),
            isCompleted: preferenceManager.getAchievementCompletion(achievementKey: DataContractIOS.keyForIsCompletedAchievementExpert3)),
        ]
    }
    
}
