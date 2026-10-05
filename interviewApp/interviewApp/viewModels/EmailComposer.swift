import SwiftUI
import MessageUI

struct EmailComposer: View {
    @ObservedObject var emailManager: EmailManager
    @State private var subject: String = ""
    @State private var emailBody: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Compose Email")) {
                    TextField("Subject", text: $subject)
                    TextEditor(text: $emailBody)
                        .frame(minHeight: 100)
                }
                
                Section {
                    Button("Send Email") {
                        // Get the file URL from the emailManager
                        emailManager.sendEmail(
                            subject: subject,
                            messageBody: emailBody,
                            toRecipients: ["dailydatascienceqa@gmail.com"],
                            attachmentURL: emailManager.attachmentURL
                        )
                    }
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding()
                }
            }
            .navigationBarTitle("Compose Email")
            .navigationBarItems(trailing: Button("Cancel") {
                // Dismiss the email composer sheet
            })
        }
    }
}
