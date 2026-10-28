import SwiftUI

struct ControlView: View {
    var onOpenScanner: () -> Void
    @EnvironmentObject var tvManager: TvManager
    
    @State private var showYouTubeAlert = false
    @State private var youtubeVideoId = "dQw4w9WgXcQ"
    @State private var showBrowserAlert = false
    @State private var browserUrl = "https://ya.ru"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                if !tvManager.isConnected {
                    // Disconnected Banner
                    VStack(spacing: 12) {
                        Image(systemName: "tv.slash")
                            .font(.system(size: 36))
                            .foregroundColor(Theme.textDim)
                        
                        Text("Телевизор не подключен")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        
                        Button(action: onOpenScanner) {
                            Text("Найти ТВ в сети")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Theme.primaryPurple)
                                .cornerRadius(12)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .cyberCard()
                } else {
                    // Connected TV Card
                    VStack(spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(tvManager.currentTv?.name ?? "Smart TV")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                
                                HStack(spacing: 8) {
                                    Text(tvManager.currentTv?.ip ?? "192.168.1.100")
                                        .font(.system(size: 11, design: .monospaced))
                                        .foregroundColor(Theme.textSecondary)
                                    Text("•")
                                        .foregroundColor(Theme.textDim)
                                    Text("\(tvManager.pingLatency) ms")
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(Theme.accentGlow)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                tvManager.disconnect()
                            }) {
                                HStack(spacing: 5) {
                                    Image(systemName: "power")
                                    Text("Отключить")
                                }
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Theme.statusRed)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Theme.statusRed.opacity(0.12))
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.statusRed.opacity(0.3), lineWidth: 1))
                            }
                        }
                    }
                    .padding(14)
                    .cyberCard()
                    
                    // Power & Screen Cards Row
                    VStack(spacing: 10) {
                        // Power Control Row (On / Off)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Питание ТВ")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Theme.textSecondary)
                            
                            HStack(spacing: 10) {
                                Button(action: {
                                    tvManager.sendWoL()
                                }) {
                                    HStack {
                                        Image(systemName: "bolt.fill")
                                        Text("On (WoL)")
                                    }
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 42)
                                    .background(tvManager.isPowerOn ? Theme.statusGreen : Theme.cardBg)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.statusGreen, lineWidth: 1))
                                }
                                
                                Button(action: {
                                    tvManager.turnOffPower()
                                }) {
                                    HStack {
                                        Image(systemName: "power")
                                        Text("Off")
                                    }
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(!tvManager.isPowerOn ? .white : Theme.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 42)
                                    .background(!tvManager.isPowerOn ? Theme.statusRed : Theme.cardBg)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
                                }
                            }
                        }
                        .padding(12)
                        .cyberCard()
                        
                        // Screen Control Row (Screen On / Screen Off)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Подсветка экрана")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Theme.textSecondary)
                            
                            HStack(spacing: 10) {
                                Button(action: {
                                    tvManager.setScreen(on: true)
                                }) {
                                    HStack {
                                        Image(systemName: "sun.max.fill")
                                        Text("Screen On")
                                    }
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 42)
                                    .background(tvManager.isScreenOn ? Theme.accentGlow.opacity(0.8) : Theme.cardBg)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.accentGlow, lineWidth: 1))
                                }
                                
                                Button(action: {
                                    tvManager.setScreen(on: false)
                                }) {
                                    HStack {
                                        Image(systemName: "moon.fill")
                                        Text("Screen Off")
                                    }
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(!tvManager.isScreenOn ? .white : Theme.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 42)
                                    .background(!tvManager.isScreenOn ? Theme.accentOrange : Theme.cardBg)
                                    .cornerRadius(12)
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
                                }
                            }
                        }
                        .padding(12)
                        .cyberCard()
                    }
                    
                    // Volume Control
                    VStack(spacing: 10) {
                        HStack {
                            Text("Громкость")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Theme.textSecondary)
                            Spacer()
                            Text("\(tvManager.volume)%")
                                .font(.system(size: 13, weight: .bold, design: .monospaced))
                                .foregroundColor(Theme.accentGlow)
                        }
                        
                        HStack(spacing: 10) {
                            Button(action: { tvManager.volumeStep(delta: -3) }) {
                                Text("-3")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.textPrimary)
                                    .frame(width: 44, height: 38)
                                    .background(Theme.cardBorder)
                                    .cornerRadius(10)
                            }
                            
                            Slider(
                                value: Binding(
                                    get: { Double(tvManager.volume) },
                                    set: { tvManager.setVolume(Int($0)) }
                                ),
                                in: 0...100
                            )
                            .tint(Theme.primaryPurpleLight)
                            
                            Button(action: { tvManager.volumeStep(delta: 3) }) {
                                Text("+3")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.textPrimary)
                                    .frame(width: 44, height: 38)
                                    .background(Theme.cardBorder)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: { tvManager.toggleMute() }) {
                                Image(systemName: tvManager.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(tvManager.isMuted ? Theme.statusRed : Theme.accentGlow)
                                    .frame(width: 44, height: 38)
                                    .background(Theme.cardBorder)
                                    .cornerRadius(10)
                            }
                        }
                        
                        // Audio Output Selector
                        HStack(spacing: 8) {
                            Text("Вывод:")
                                .font(.system(size: 10))
                                .foregroundColor(Theme.textDim)
                            
                            Button(action: { tvManager.setAudioSink("Динамик ТВ") }) {
                                Text("Динамик ТВ")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(tvManager.audioSink == "Динамик ТВ" ? Theme.accentGlow : Theme.textSecondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(tvManager.audioSink == "Динамик ТВ" ? Theme.primaryPurple.opacity(0.3) : Theme.cardBorder)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: { tvManager.setAudioSink("HDMI (eARC)") }) {
                                Text("HDMI (eARC)")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(tvManager.audioSink == "HDMI (eARC)" ? Theme.accentGlow : Theme.textSecondary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(tvManager.audioSink == "HDMI (eARC)" ? Theme.primaryPurple.opacity(0.3) : Theme.cardBorder)
                                    .cornerRadius(8)
                            }
                            Spacer()
                        }
                    }
                    .padding(12)
                    .cyberCard()
                    
                    // Magic Remote D-Pad
                    VStack(spacing: 12) {
                        HStack {
                            Text("Пульт Magic Remote")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Theme.textSecondary)
                            Spacer()
                        }
                        
                        // D-Pad Circle
                        VStack(spacing: 6) {
                            Button(action: { tvManager.sendKey("UP") }) {
                                Image(systemName: "chevron.up")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Theme.textPrimary)
                                    .frame(width: 46, height: 38)
                                    .background(Theme.cardBorder)
                                    .cornerRadius(10)
                            }
                            
                            HStack(spacing: 6) {
                                Button(action: { tvManager.sendKey("LEFT") }) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Theme.textPrimary)
                                        .frame(width: 46, height: 38)
                                    .background(Theme.cardBorder)
                                    .cornerRadius(10)
                                }
                                
                                Button(action: { tvManager.sendKey("ENTER") }) {
                                    Text("OK")
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(width: 48, height: 48)
                                        .background(Theme.primaryPurple)
                                        .cornerRadius(24)
                                        .shadow(color: Theme.primaryPurple.opacity(0.6), radius: 6)
                                }
                                
                                Button(action: { tvManager.sendKey("RIGHT") }) {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Theme.textPrimary)
                                        .frame(width: 46, height: 38)
                                    .background(Theme.cardBorder)
                                    .cornerRadius(10)
                                }
                            }
                            
                            Button(action: { tvManager.sendKey("DOWN") }) {
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Theme.textPrimary)
                                    .frame(width: 46, height: 38)
                                    .background(Theme.cardBorder)
                                    .cornerRadius(10)
                            }
                        }
                        
                        // Home & Back
                        HStack(spacing: 20) {
                            Button(action: { tvManager.sendKey("HOME") }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "house.fill")
                                    Text("Home")
                                }
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Theme.textSecondary)
                                .frame(width: 90, height: 34)
                                .background(Theme.cardBorder)
                                .cornerRadius(10)
                            }
                            
                            Button(action: { tvManager.sendKey("BACK") }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.uturn.backward")
                                    Text("Back")
                                }
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Theme.textSecondary)
                                .frame(width: 90, height: 34)
                                .background(Theme.cardBorder)
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(12)
                    .cyberCard()
                    
                    // Video Inputs
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Видеовходы")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Theme.textSecondary)
                        
                        HStack(spacing: 8) {
                            ForEach(["HDMI 1", "HDMI 2", "HDMI 3", "LiveTV"], id: \.self) { input in
                                Button(action: { tvManager.setInput(input) }) {
                                    Text(input)
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(Theme.textPrimary)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 36)
                                        .background(Theme.cardBorder)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding(12)
                    .cyberCard()
                    
                    // Quick Apps (YouTube, Browser)
                    HStack(spacing: 10) {
                        Button(action: { showYouTubeAlert = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "play.rectangle.fill")
                                    .foregroundColor(Theme.statusRed)
                                Text("YouTube")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.textPrimary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .cyberCard()
                        }
                        
                        Button(action: { showBrowserAlert = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "globe")
                                    .foregroundColor(Theme.accentGlow)
                                Text("Браузер")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Theme.textPrimary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .cyberCard()
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .alert("Открыть YouTube видео", isPresented: $showYouTubeAlert) {
            TextField("ID или ссылка (напр. dQw4w9WgXcQ)", text: $youtubeVideoId)
            Button("Запустить") {
                tvManager.openYouTube(videoIdOrUrl: youtubeVideoId)
            }
            Button("Отмена", role: .cancel) {}
        }
        .alert("Открыть сайт в ТВ", isPresented: $showBrowserAlert) {
            TextField("URL адрес (напр. ya.ru)", text: $browserUrl)
            Button("Перейти") {
                tvManager.openBrowser(url: browserUrl)
            }
            Button("Отмена", role: .cancel) {}
        }
    }
}
