import SwiftUI
import Foundation
//import AppTrackingTransparency
import GoogleMobileAds

@main
struct DateScienceDailyQuizApp: App {
    
    //Use init() in place of ApplicationDidFinishLaunchWithOptions in App Delegate
        init() {
//            if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
//                print("notDetermined ")
//                //User has not indicated their choice for app tracking
//                //You may want to show a pop-up explaining why you are collecting their data
//                //Toggle any variables to do this here
//            } else {
//                print("determined")
//                ATTrackingManager.requestTrackingAuthorization { status in
//                    //Whether or not user has opted in initialize GADMobileAds here it will handle the rest
//    
                   GADMobileAds.sharedInstance().start(completionHandler: nil)
//                }
//            }
            print("DateScienceDailyQuizApp init")
            
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    
    @State private var isLogoVisible = true
    @StateObject var updateTimeClass = UpdateTimeForLife()
    
    init() {
        // eachtime need to reset time passed during app
        let preferenceManager = PreferenceManager.shared
        preferenceManager.updateCounterForEachUsage(counterForEachUsage: 0)
        print("getExperience \(preferenceManager.getExperience())")
        
        let isFirstOpening = PreferenceManager.shared.getIsFirstOpening()
        if isFirstOpening {
            preferenceManager.updateUserLife(userLife: DataContractIOS.maxUserLife)
            preferenceManager.updateIsFirstOpening(isFirstOpening: false)
        }
    }
    
    
    var body: some View {
        // Display the logo for a certain duration
        ZStack{
            Color.gray.opacity(0.1)
        
        if isLogoVisible {
            Image("logo") // Replace with your logo image asset
                       .resizable() // Allows the image to resize
                       .aspectRatio(contentMode: .fit) // Keeps the logo's aspect ratio intact
                       .frame(width: 200, height: 200) // Specify the size you want for your logo
                .onAppear {
                    // Delay for 2 seconds (2000 milliseconds) before transitioning to the main view
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isLogoVisible = false
                            updateTimeClass.checkTimeBetweenAppCloseandOpen()
                        }
                    }
                }
        } else {
            // After the logo is no longer visible, navigate to the main view
            NavigationView {
                MainView()
            }
        }
        
    }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
