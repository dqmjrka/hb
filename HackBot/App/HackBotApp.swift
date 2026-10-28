import SwiftUI

@main
struct HackBotApp: App {
    @StateObject private var tvManager = TvManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(tvManager)
                .preferredColorScheme(.dark)
        }
    }
}

enum AppRoute {
    case welcome
    case main
    case settings
}

struct ContentView: View {
    @EnvironmentObject var tvManager: TvManager
    @State private var route: AppRoute = .welcome
    @State private var showConnectModal: Bool = false
    
    var body: some View {
        ZStack {
            Theme.darkBg.ignoresSafeArea()
            
            Group {
                switch route {
                case .welcome:
                    WelcomeView(
                        onStartTapped: {
                            showConnectModal = true
                        },
                        onNavigateToMain: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                route = .main
                            }
                        }
                    )
                    
                case .main:
                    MainTabView(
                        onOpenSettings: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                route = .settings
                            }
                        },
                        onOpenScanner: {
                            showConnectModal = true
                        }
                    )
                    
                case .settings:
                    SettingsView(
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                route = .main
                            }
                        }
                    )
                }
            }
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .scale(scale: 0.98)),
                removal: .opacity
            ))
        }
        .sheet(isPresented: $showConnectModal) {
            ConnectModalView(
                isPresented: $showConnectModal,
                onConnected: {
                    showConnectModal = false
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        route = .main
                    }
                }
            )
            .environmentObject(tvManager)
        }
    }
}
