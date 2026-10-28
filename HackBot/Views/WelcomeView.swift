import SwiftUI

struct WelcomeView: View {
    var onStartTapped: () -> Void
    var onNavigateToMain: () -> Void
    
    @EnvironmentObject var tvManager: TvManager
    @State private var isPulsing: Bool = false
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Neon Logo
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Theme.primaryPurple.opacity(0.4),
                                Theme.accentGlow.opacity(0.15),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(isPulsing ? 1.15 : 0.95)
                    .animation(
                        Animation.easeInOut(duration: 2.2).repeatForever(autoreverses: true),
                        value: isPulsing
                    )
                
                Circle()
                    .fill(Theme.cardBg)
                    .frame(width: 110, height: 110)
                    .overlay(
                        Circle().stroke(
                            LinearGradient(
                                colors: [Theme.accentGlow, Theme.primaryPurple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                    )
                    .shadow(color: Theme.accentGlow.opacity(0.5), radius: 15)
                
                Image(systemName: "tv.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .foregroundColor(Theme.accentGlow)
            }
            .onAppear {
                isPulsing = true
            }
            
            Spacer().frame(height: 32)
            
            // Title
            Text("HackBot")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
                .shadow(color: Theme.primaryPurple.opacity(0.8), radius: 10)
            
            Spacer().frame(height: 8)
            
            // Subtitle
            Text("V1.0 (by @HackBot_TV)")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(Theme.accentGlow)
            
            Spacer().frame(height: 16)
            
            Text("Управление и розыгрыши над Smart TV\nпо локальной сети Wi-Fi")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 12) {
                // Start Button
                Button(action: {
                    if tvManager.isConnected {
                        onNavigateToMain()
                    } else {
                        onStartTapped()
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 18, weight: .bold))
                        Text(tvManager.isConnected ? "Открыть панель" : "Start")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        LinearGradient(
                            colors: [Theme.primaryPurpleLight, Theme.primaryPurple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Theme.primaryPurple.opacity(0.5), radius: 8, y: 4)
                }
                
                // Telegram Button
                Button(action: {
                    if let url = URL(string: "https://t.me/hackbot_tv") {
                        openURL(url)
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16))
                        Text("Telegram")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(Theme.accentGlow)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Theme.cardBg)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.cardBorder, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 40)
        }
    }
}
