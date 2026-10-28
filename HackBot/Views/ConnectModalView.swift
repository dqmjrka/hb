import SwiftUI

struct ConnectModalView: View {
    @Binding var isPresented: Bool
    var onConnected: () -> Void
    
    @EnvironmentObject var tvManager: TvManager
    @State private var radarAngle: Double = 0
    @State private var showManualIpAlert: Bool = false
    @State private var manualIp: String = "192.168.1."
    @State private var manualName: String = "Мой ТВ"
    
    var body: some View {
        ZStack {
            Theme.darkBg.ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Поиск телевизоров")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        Text("Устройства в сети Wi-Fi")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Theme.textDim)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Radar Pulse View
                ZStack {
                    Circle()
                        .stroke(Theme.cardBorder, lineWidth: 1)
                        .frame(width: 140, height: 140)
                    
                    Circle()
                        .stroke(Theme.accentGlow.opacity(0.3), lineWidth: 1)
                        .frame(width: 90, height: 90)
                    
                    Circle()
                        .fill(Theme.cardBg)
                        .frame(width: 44, height: 44)
                        .overlay(Circle().stroke(Theme.accentGlow, lineWidth: 2))
                    
                    Image(systemName: "wifi")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.accentGlow)
                    
                    // Rotating radar sweep
                    Circle()
                        .trim(from: 0, to: 0.25)
                        .stroke(
                            AngularGradient(
                                colors: [Theme.accentGlow.opacity(0.8), Color.clear],
                                center: .center
                            ),
                            lineWidth: 70
                        )
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(radarAngle))
                }
                .frame(height: 150)
                .onAppear {
                    withAnimation(Animation.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                        radarAngle = 360
                    }
                    tvManager.startScan()
                }
                
                // Action row: Rescan / Manual IP
                HStack(spacing: 10) {
                    Button(action: {
                        tvManager.startScan()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.clockwise")
                                .rotationEffect(.degrees(tvManager.isScanning ? 360 : 0))
                                .animation(tvManager.isScanning ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: tvManager.isScanning)
                            Text(tvManager.isScanning ? "Поиск..." : "Обновить")
                        }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Theme.accentGlow)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Theme.cardBg)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
                    }
                    
                    Button(action: {
                        showManualIpAlert = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle")
                            Text("Ввести IP вручную")
                        }
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Theme.cardBg)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
                    }
                }
                
                // Device List
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(tvManager.discoveredTvs) { tv in
                            Button(action: {
                                tvManager.connectToTv(tv)
                            }) {
                                HStack(spacing: 14) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Theme.primaryPurple.opacity(0.15))
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: "tv")
                                            .font(.system(size: 20))
                                            .foregroundColor(Theme.accentGlow)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(tv.name)
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundColor(Theme.textPrimary)
                                        
                                        HStack(spacing: 6) {
                                            Text(tv.ip)
                                                .font(.system(size: 11, design: .monospaced))
                                                .foregroundColor(Theme.textSecondary)
                                            Text("•")
                                                .foregroundColor(Theme.textDim)
                                            Text(tv.type)
                                                .font(.system(size: 11))
                                                .foregroundColor(Theme.accentGlow)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Theme.textDim)
                                }
                                .padding(12)
                                .cyberCard(cornerRadius: 14)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            // Pairing Confirmation Modal Dialog
            if tvManager.pairingState == .promptSent || tvManager.pairingState == .connecting {
                Color.black.opacity(0.75).ignoresSafeArea()
                
                VStack(spacing: 18) {
                    if tvManager.pairingState == .connecting {
                        ProgressView()
                            .scaleEffect(1.3)
                            .tint(Theme.accentGlow)
                        
                        Text("Подключение к ТВ...")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                    } else {
                        Image(systemName: "tv.badge.wifi.fill")
                            .font(.system(size: 42))
                            .foregroundColor(Theme.accentGlow)
                        
                        Text("📺 На экране ТВ появится запрос.")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Text("Возьмите пульт от телевизора и нажмите\n**ДА / РАЗРЕШИТЬ**...")
                            .font(.system(size: 13))
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: 10) {
                            Button(action: {
                                tvManager.confirmPairing()
                                onConnected()
                            }) {
                                Text("Я нажал «Разрешить» (Подключиться)")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 46)
                                    .background(
                                        LinearGradient(
                                            colors: [Theme.statusGreen, Theme.accentGlow],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(12)
                            }
                            
                            Button(action: {
                                tvManager.cancelPairing()
                            }) {
                                Text("Отмена")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Theme.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 38)
                            }
                        }
                    }
                }
                .padding(24)
                .background(Theme.cardBg)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Theme.primaryPurple, lineWidth: 1.5))
                .shadow(color: Theme.primaryPurple.opacity(0.4), radius: 20)
                .padding(.horizontal, 32)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .alert("Добавить ТВ вручную", isPresented: $showManualIpAlert) {
            TextField("Название", text: $manualName)
            TextField("IP адрес (напр. 192.168.1.105)", text: $manualIp)
            Button("Добавить") {
                let newTv = TvDevice(name: manualName, ip: manualIp)
                tvManager.discoveredTvs.insert(newTv, at: 0)
                tvManager.connectToTv(newTv)
            }
            Button("Отмена", role: .cancel) {}
        }
    }
}
