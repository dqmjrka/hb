import SwiftUI

struct ConsoleView: View {
    @EnvironmentObject var tvManager: TvManager
    @State private var commandInput: String = ""
    @State private var showOpcodeSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Quick Command Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    Button(action: { showOpcodeSheet = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "questionmark.circle")
                            Text("Справка / Opcodes")
                        }
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Theme.accentGlow)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Theme.cardBg)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.accentGlow.opacity(0.5), lineWidth: 1))
                    }
                    
                    QuickChip(title: "help", cmd: "help")
                    QuickChip(title: "status", cmd: "status")
                    QuickChip(title: "wol", cmd: "wol")
                    QuickChip(title: "screen off", cmd: "screen off")
                    QuickChip(title: "vol 30", cmd: "vol 30")
                    QuickChip(title: "stop", cmd: "stop", color: Theme.statusRed)
                    QuickChip(title: "clear", cmd: "clear")
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 4)
            
            // Terminal Box
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(tvManager.terminalLogs) { line in
                            HStack(alignment: .top, spacing: 6) {
                                Text("[\(line.timestamp)]")
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(Theme.textDim)
                                
                                Text(line.text)
                                    .font(.system(size: 11, weight: line.isCommand ? .bold : .regular, design: .monospaced))
                                    .foregroundColor(Color(hex: line.colorHex))
                            }
                            .id(line.id)
                        }
                    }
                    .padding(10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: "#080A10"))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
                .padding(.horizontal, 16)
                .onChange(of: tvManager.terminalLogs.count) { _ in
                    if let last = tvManager.terminalLogs.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Command Input Row
            HStack(spacing: 8) {
                HStack(spacing: 6) {
                    Text(">")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(Theme.accentGlow)
                    
                    TextField("Введите команду (напр. help, wol)...", text: $commandInput)
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(Theme.textPrimary)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onSubmit {
                            submitCommand()
                        }
                }
                .padding(.horizontal, 12)
                .frame(height: 42)
                .background(Theme.cardBg)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.cardBorder, lineWidth: 1))
                
                Button(action: submitCommand) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Theme.accentGlow)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 6)
        }
        .sheet(isPresented: $showOpcodeSheet) {
            OpcodeHelpSheet(
                onSelectCommand: { cmd in
                    commandInput = cmd
                    showOpcodeSheet = false
                }
            )
        }
    }
    
    private func submitCommand() {
        let cmd = commandInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cmd.isEmpty else { return }
        tvManager.executeCommand(cmd)
        commandInput = ""
    }
}

struct QuickChip: View {
    let title: String
    let cmd: String
    var color: Color = Theme.textSecondary
    @EnvironmentObject var tvManager: TvManager
    
    var body: some View {
        Button(action: {
            tvManager.executeCommand(cmd)
        }) {
            Text(title)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(color)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Theme.cardBg)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.cardBorder, lineWidth: 1))
        }
    }
}

struct OpcodeHelpSheet: View {
    var onSelectCommand: (String) -> Void
    @Environment(\.dismiss) var dismiss
    
    let commands = [
        ("help", "Показать полный список доступных команд"),
        ("status", "Телеметрия ТВ (пинг, громкость, статус питания)"),
        ("wol", "Отправка Magic Packet по Wake-on-LAN на MAC-адрес"),
        ("power on", "Включить телевизор"),
        ("power off", "Перевести телевизор в режим сна / ожидания"),
        ("screen on", "Включить подсветку матрицы"),
        ("screen off", "Погасить подсветку (звук продолжает играть)"),
        ("vol 35", "Установить точный уровень громкости (0..100)"),
        ("mute", "Полностью заглушить звук"),
        ("unmute", "Включить звук обратно"),
        ("key OK", "Нажать кнопку пульта (UP, DOWN, LEFT, RIGHT, OK, BACK)"),
        ("yt dQw4w9WgXcQ", "Открыть видео YouTube по ID или ссылке"),
        ("url https://ya.ru", "Открыть веб-сайт в браузере ТВ"),
        ("prank 1", "🔥 Ошибка критического перегрева"),
        ("prank 2", "⚡ Стробоскоп экраном на 5 секунд"),
        ("prank 3", "🔌 Микро-глюк (погасить на 1.2 сек)"),
        ("prank 4", "📺 Вечное кабельное (цикл каналов)"),
        ("prank 5", "🔇 Фантомный Mute на 3.5 секунды"),
        ("prank 6", "🌊 Горки звука (разгон громкости до 36 и в ноль)"),
        ("prank 7", "📉 Сползание громкости"),
        ("prank 8", "⏸ Полтергейст кнопки паузы"),
        ("stop", "Экстренно остановить все запущенные пранки"),
        ("clear", "Очистить терминал")
    ]
    
    var body: some View {
        ZStack {
            Theme.darkBg.ignoresSafeArea()
            
            VStack(spacing: 12) {
                HStack {
                    Text("Справочник команд (CLI)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Theme.textDim)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                List {
                    ForEach(commands, id: \.0) { cmd, desc in
                        Button(action: {
                            onSelectCommand(cmd)
                        }) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(cmd)
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    .foregroundColor(Theme.accentGlow)
                                Text(desc)
                                    .font(.system(size: 11))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(Theme.cardBg)
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}
