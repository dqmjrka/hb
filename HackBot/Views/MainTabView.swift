import SwiftUI

enum MainTab: Int, CaseIterable {
    case control = 0
    case status = 1
    case pranks = 2
    case console = 3
    
    var title: String {
        switch self {
        case .control: return "Control"
        case .status: return "Status"
        case .pranks: return "Pranks"
        case .console: return "Console"
        }
    }
    
    var icon: String {
        switch self {
        case .control: return "slider.horizontal.3"
        case .status: return "waveform.path.ecg"
        case .pranks: return "flame.fill"
        case .console: return "terminal.fill"
        }
    }
}

struct MainTabView: View {
    var onOpenSettings: () -> Void
    var onOpenScanner: () -> Void
    
    @EnvironmentObject var tvManager: TvManager
    @State private var selectedTab: MainTab = .control
    
    var body: some View {
        VStack(spacing: 0) {
            // Top App Bar
            HStack(spacing: 12) {
                // TV Status Pill
                Button(action: {
                    onOpenScanner()
                }) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(tvManager.isConnected ? Theme.statusGreen : Theme.statusRed)
                            .frame(width: 8, height: 8)
                            .shadow(color: (tvManager.isConnected ? Theme.statusGreen : Theme.statusRed).opacity(0.8), radius: 4)
                        
                        Text(tvManager.isConnected ? (tvManager.currentTv?.name ?? "Connected TV") : "Подключить ТВ")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                            .lineLimit(1)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Theme.textDim)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(Theme.cardBg)
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Theme.cardBorder, lineWidth: 1))
                }
                
                Spacer()
                
                // Settings button
                Button(action: {
                    onOpenSettings()
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 17))
                        .foregroundColor(Theme.textSecondary)
                        .frame(width: 38, height: 38)
                        .background(Theme.cardBg)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Theme.darkBg)
            
            // Tab Contents
            ZStack {
                switch selectedTab {
                case .control:
                    ControlView(onOpenScanner: onOpenScanner)
                case .status:
                    StatusView()
                case .pranks:
                    PranksView()
                case .console:
                    ConsoleView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Neon Bottom Bar
            HStack(spacing: 0) {
                ForEach(MainTab.allCases, id: \.self) { tab in
                    let isSelected = selectedTab == tab
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 18, weight: isSelected ? .bold : .regular))
                                .foregroundColor(isSelected ? Theme.accentGlow : Theme.textDim)
                                .scaleEffect(isSelected ? 1.12 : 1.0)
                            
                            Text(tab.title)
                                .font(.system(size: 10, weight: isSelected ? .bold : .medium, design: .rounded))
                                .foregroundColor(isSelected ? Theme.accentGlow : Theme.textDim)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            isSelected ?
                            Theme.primaryPurple.opacity(0.12) : Color.clear
                        )
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(Theme.cardBg)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Theme.cardBorder),
                alignment: .top
            )
        }
    }
}
