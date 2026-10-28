import SwiftUI

struct SettingsView: View {
    var onBack: () -> Void
    @EnvironmentObject var tvManager: TvManager
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .bold))
                        Text("Назад")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(Theme.accentGlow)
                }
                
                Spacer()
                
                Text("Настройки")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                // Balance layout
                Color.clear.frame(width: 60, height: 20)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            ScrollView {
                VStack(spacing: 16) {
                    // App Card
                    VStack(spacing: 8) {
                        Image(systemName: "tv.fill")
                            .font(.system(size: 38))
                            .foregroundColor(Theme.accentGlow)
                        
                        Text("HackBot")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        
                        Text("V1.0 (by @HackBot_TV)")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(Theme.accentGlow)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .cyberCard()
                    
                    // Links Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Официальные ресурсы")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.textSecondary)
                        
                        // Telegram
                        Button(action: {
                            if let url = URL(string: "https://t.me/hackbot_tv") {
                                openURL(url)
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(Theme.accentGlow)
                                
                                Text("Telegram")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                
                                Spacer()
                                
                                Text("@HackBot_TV")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.textSecondary)
                                
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Theme.textDim)
                            }
                            .padding(14)
                            .cyberCard()
                        }
                        
                        // Site
                        Button(action: {
                            if let url = URL(string: "https://hb.ttdq.pro") {
                                openURL(url)
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "globe")
                                    .font(.system(size: 16))
                                    .foregroundColor(Theme.primaryPurpleLight)
                                
                                Text("Site")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                
                                Spacer()
                                
                                Text("hb.ttdq.pro")
                                    .font(.system(size: 12))
                                    .foregroundColor(Theme.textSecondary)
                                
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Theme.textDim)
                            }
                            .padding(14)
                            .cyberCard()
                        }
                    }
                    
                    // Demo Mode Switch
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Режим работы")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.textSecondary)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Демо-режим")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.textPrimary)
                                Text("Тестирование всех функций без реального ТВ")
                                    .font(.system(size: 11))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $tvManager.isDemoMode)
                                .tint(Theme.accentGlow)
                                .labelsHidden()
                        }
                        .padding(14)
                        .cyberCard()
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
