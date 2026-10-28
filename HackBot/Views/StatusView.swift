import SwiftUI

struct StatusView: View {
    @EnvironmentObject var tvManager: TvManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack {
                    Text("Телеметрия устройства")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                    Spacer()
                }
                
                // Device Info Card
                VStack(spacing: 12) {
                    StatusRow(label: "Модель ТВ", value: tvManager.currentTv?.model ?? "Не подключено")
                    StatusRow(label: "Сетевое имя", value: tvManager.currentTv?.name ?? "—")
                    StatusRow(label: "Платформа", value: tvManager.currentTv?.type ?? "—")
                    StatusRow(label: "IP адрес", value: tvManager.currentTv?.ip ?? "—", isMono: true)
                    StatusRow(label: "MAC адрес", value: tvManager.currentTv?.mac ?? "—", isMono: true)
                    StatusRow(label: "Задержка сети (Ping)", value: tvManager.isConnected ? "\(tvManager.pingLatency) ms" : "—", isAccent: true)
                }
                .padding(14)
                .cyberCard()
                
                HStack {
                    Text("Текущие параметры")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                    Spacer()
                }
                
                // State Card
                VStack(spacing: 12) {
                    StatusRow(
                        label: "Статус питания",
                        value: tvManager.isPowerOn ? "ВКЛЮЧЕН" : "РЕЖИМ ОЖИДАНИЯ",
                        color: tvManager.isPowerOn ? Theme.statusGreen : Theme.statusRed
                    )
                    StatusRow(
                        label: "Подсветка матрицы",
                        value: tvManager.isScreenOn ? "АКТИВНА" : "ПОГАШЕНА",
                        color: tvManager.isScreenOn ? Theme.accentGlow : Theme.accentOrange
                    )
                    StatusRow(label: "Уровень громкости", value: "\(tvManager.volume)%")
                    StatusRow(
                        label: "Режим звука",
                        value: tvManager.isMuted ? "MUTE (Заглушен)" : "Нормальный",
                        color: tvManager.isMuted ? Theme.statusRed : Theme.textPrimary
                    )
                    StatusRow(label: "Аудио-выход", value: tvManager.audioSink)
                    StatusRow(
                        label: "Активный розыгрыш",
                        value: tvManager.activePrank ?? "Нет",
                        color: tvManager.activePrank != nil ? Theme.statusRed : Theme.textSecondary
                    )
                }
                .padding(14)
                .cyberCard()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }
}

struct StatusRow: View {
    let label: String
    let value: String
    var isMono: Bool = false
    var isAccent: Bool = false
    var color: Color = Theme.textPrimary
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(
                    isMono ?
                    .system(size: 12, weight: .medium, design: .monospaced) :
                    .system(size: 12, weight: .semibold, design: .rounded)
                )
                .foregroundColor(isAccent ? Theme.accentGlow : color)
        }
    }
}
