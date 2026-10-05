import SwiftUI

struct AchievementCardView: View {
    var title: String
    var description: String
    var date: String
    var image: Image // This will be the star image you mentioned

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]), startPoint: .top, endPoint: .bottom))
                .frame(width: 200, height: 300)
                .shadow(radius: 10)

            VStack {
                Text(date.uppercased())
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.8))
                    .clipShape(Capsule())

                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(20)
                    .background(Circle().fill(Color.white.opacity(0.8)))

                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal)
            }
            .padding(.top, 20)
        }
    }
}

struct AchView: View {
    var body: some View {
        VStack {
            AchievementCardView(title: "Passage Lighthouse",
                                description: "Complete Level 1",
                                date: "August 15, 2020",
                                image: Image(systemName: "star.fill"))
            // You can replace Image(systemName: "star.fill") with any other custom image
        }
    }
}


