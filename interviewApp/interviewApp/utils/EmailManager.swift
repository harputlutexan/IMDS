import Foundation
import MessageUI

class EmailManager: NSObject, MFMailComposeViewControllerDelegate, ObservableObject {
    @Published var isMailComposePresented: Bool = false
    var attachmentURL: URL? {
            didSet {
                // Notify observers that the value has changed
                objectWillChange.send()
            }
        }

    // Add any other properties you want to observe

    func sendEmail(subject: String, messageBody: String, toRecipients: [String], attachmentURL: URL? = nil) {
        guard MFMailComposeViewController.canSendMail() else {
            // Handle the case where the device is not configured to send emails
            return
        }

        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipients)
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let filePath = documentsDirectory.appendingPathComponent(DataContractIOS.newCSVFileName).path
//        let fileURL = URL(fileURLWithPath: filePath)

        
        if let attachmentURL = attachmentURL {
            do {
                let attachmentData = try Data(contentsOf: attachmentURL)
                mailComposer.addAttachmentData(attachmentData, mimeType: "application/csv", fileName: attachmentURL.lastPathComponent)
            } catch {
                print("Error loading attachment data: \(error)")
            }
        }

        // Set the attachmentURL property for later use
        self.attachmentURL = attachmentURL

        // Present the mail composer view controller
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let topViewController = windowScene.windows.first?.rootViewController {
            
            topViewController.present(mailComposer, animated: true) {
                // Set the flag when the mail composer is presented
                self.isMailComposePresented = true
            }
        }
    }

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            // Reset the flag when the mail composer is dismissed
            self.isMailComposePresented = false
        }
    }
}
