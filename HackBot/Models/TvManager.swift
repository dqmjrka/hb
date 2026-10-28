import Foundation
import SwiftUI
import Network

@MainActor
class TvManager: ObservableObject {
    @Published var currentTv: TvDevice?
    @Published var discoveredTvs: [TvDevice] = []
    @Published var isScanning: Bool = false
    @Published var isConnected: Bool = false
    @Published var isPowerOn: Bool = true
    @Published var isScreenOn: Bool = true
    @Published var volume: Int = 18
    @Published var isMuted: Bool = false
    @Published var audioSink: String = "Динамик ТВ"
    @Published var activePrank: String? = nil
    @Published var terminalLogs: [TerminalLine] = []
    @Published var pairingState: PairingState = .idle
    @Published var isDemoMode: Bool = true
    @Published var pingLatency: Int = 14
    
    private var prankTasks: [Task<Void, Never>] = []
    private var originalVolume: Int = 18
    private var originalScreenState: Bool = true
    
    init() {
        addLog("HackBot Core v1.0 [iOS Engine Initialized]", colorHex: "#00CEC9")
        addLog("Enter 'help' in Console for command reference.", colorHex: "#8E9BB5")
    }
    
    func addLog(_ text: String, isCmd: Bool = false, colorHex: String = "#8E9BB5") {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let timeStr = formatter.string(from: Date())
        let line = TerminalLine(timestamp: timeStr, text: text, isCommand: isCmd, colorHex: colorHex)
        terminalLogs.append(line)
        if terminalLogs.count > 120 {
            terminalLogs.removeFirst(terminalLogs.count - 120)
        }
    }
    
    // MARK: - Discovery & Pairing
    
    func startScan() {
        isScanning = true
        discoveredTvs.removeAll()
        addLog("Сканирование подсети Wi-Fi на наличие Smart TV...", colorHex: "#6C5CE7")
        
        Task {
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            
            // Standard demo / discovered TVs
            let tvs = [
                TvDevice(name: "LG OLED55C1 Living Room", ip: "192.168.1.105", mac: "00:E0:4C:68:01:22", model: "OLED55C1RLA", type: "LG WebOS 6.0"),
                TvDevice(name: "Samsung QLED 65 Bedroom", ip: "192.168.1.120", mac: "48:44:F7:99:A1:33", model: "QE65Q80AAU", type: "Samsung Tizen 6.5"),
                TvDevice(name: "Xiaomi TV Master Kitchen", ip: "192.168.1.144", mac: "7C:49:EB:12:34:56", model: "L65M5-OD", type: "Android TV 11")
            ]
            
            self.discoveredTvs = tvs
            self.isScanning = false
            self.addLog("Найдено устройств: \(tvs.count)", colorHex: "#00B894")
        }
    }
    
    func connectToTv(_ tv: TvDevice) {
        currentTv = tv
        pairingState = .connecting
        addLog("Подключение к \(tv.name) (\(tv.ip))...", colorHex: "#6C5CE7")
        
        Task {
            try? await Task.sleep(nanoseconds: 900_000_000)
            self.pairingState = .promptSent
            self.addLog("Запрос сопряжения отправлен на экран ТВ...", colorHex: "#FDCB6E")
        }
    }
    
    func confirmPairing() {
        guard let tv = currentTv else { return }
        isConnected = true
        isPowerOn = true
        isScreenOn = true
        pairingState = .success
        pingLatency = Int.random(in: 11...24)
        addLog("✔ Успешно подключено: \(tv.name)", colorHex: "#00B894")
    }
    
    func cancelPairing() {
        pairingState = .idle
        currentTv = nil
    }
    
    func disconnect() {
        guard let tv = currentTv else { return }
        stopAllPranks()
        isConnected = false
        pairingState = .idle
        addLog("Отключено от \(tv.name)", colorHex: "#E17055")
        currentTv = nil
    }
    
    // MARK: - Power & Screen Controls
    
    func sendWoL() {
        guard let tv = currentTv else { return }
        addLog("WoL: Отправка Magic Packet на MAC [\(tv.mac)]...", colorHex: "#00CEC9")
        
        sendWakeOnLanPacket(mac: tv.mac)
        
        isPowerOn = true
        addLog("Телевизор включен по сигналу Wake-on-LAN", colorHex: "#00B894")
    }
    
    func turnOffPower() {
        isPowerOn = false
        addLog("Команда Power Off отправлена (устройство переведено в режим ожидания)", colorHex: "#E17055")
    }
    
    func turnOnPower() {
        isPowerOn = true
        addLog("Команда Power On отправлена", colorHex: "#00B894")
    }
    
    func setScreen(on: Bool) {
        isScreenOn = on
        addLog(on ? "Экран включен (Screen On)" : "Экран погашен (Screen Off)", colorHex: on ? "#00B894" : "#E17055")
    }
    
    // MARK: - Volume & Audio
    
    func setVolume(_ vol: Int) {
        let clamped = max(0, min(100, vol))
        volume = clamped
        addLog("Громкость установлена: \(clamped)%", colorHex: "#8E9BB5")
    }
    
    func volumeStep(delta: Int) {
        setVolume(volume + delta)
    }
    
    func toggleMute() {
        isMuted.toggle()
        addLog(isMuted ? "Звук отключен (MUTE)" : "Звук включен (UNMUTE)", colorHex: isMuted ? "#E17055" : "#00B894")
    }
    
    func setAudioSink(_ sink: String) {
        audioSink = sink
        addLog("Аудио-выход переключен на: \(sink)", colorHex: "#6C5CE7")
    }
    
    // MARK: - Remote Navigation & Media
    
    func sendKey(_ key: String) {
        addLog("Нажата кнопка пульта: \(key)", colorHex: "#00CEC9")
    }
    
    func setInput(_ input: String) {
        addLog("Вход переключен на: \(input)", colorHex: "#6C5CE7")
    }
    
    func openYouTube(videoIdOrUrl: String) {
        addLog("Запуск YouTube видео: \(videoIdOrUrl)", colorHex: "#D63031")
    }
    
    func openBrowser(url: String) {
        var cleanUrl = url.trimmingCharacters(in: .whitespacesAndNewlines)
        if !cleanUrl.starts(with: "http://") && !cleanUrl.starts(with: "https://") {
            cleanUrl = "https://" + cleanUrl
        }
        addLog("Открытие браузера с URL: \(cleanUrl)", colorHex: "#0984E3")
    }
    
    // MARK: - 8 Pranks Implementation
    
    func prankOverheat() {
        stopAllPranks()
        activePrank = "🔥 Ошибка перегрева"
        addLog("ПРАНК: 'Ошибка перегрева' запущен! Вывод фейкового оверлея 98°C...", colorHex: "#E17055")
        
        let task = Task {
            try? await Task.sleep(nanoseconds: 7_000_000_000)
            if !Task.isCancelled {
                self.activePrank = nil
                self.addLog("ПРАНК: 'Ошибка перегрева' завершен.", colorHex: "#00B894")
            }
        }
        prankTasks.append(task)
    }
    
    func prankStrobe() {
        stopAllPranks()
        activePrank = "⚡ Стробоскоп 5 сек"
        originalScreenState = isScreenOn
        addLog("ПРАНК: 'Стробоскоп' запущен! Мерцание экраном...", colorHex: "#FDCB6E")
        
        let task = Task {
            for _ in 0..<10 {
                if Task.isCancelled { break }
                self.isScreenOn.toggle()
                try? await Task.sleep(nanoseconds: 400_000_000)
            }
            if !Task.isCancelled {
                self.isScreenOn = self.originalScreenState
                self.activePrank = nil
                self.addLog("ПРАНК: 'Стробоскоп' завершен. Экран восстановлен.", colorHex: "#00B894")
            }
        }
        prankTasks.append(task)
    }
    
    func prankGlitch() {
        stopAllPranks()
        activePrank = "🔌 Микро-глюк"
        originalScreenState = isScreenOn
        isScreenOn = false
        addLog("ПРАНК: 'Микро-глюк' - гасим экран на 1.2 сек...", colorHex: "#00CEC9")
        
        let task = Task {
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            if !Task.isCancelled {
                self.isScreenOn = true
                self.activePrank = nil
                self.addLog("ПРАНК: 'Микро-глюк' завершен. Экран включен обратно.", colorHex: "#00B894")
            }
        }
        prankTasks.append(task)
    }
    
    func prankCableLoop() {
        stopAllPranks()
        activePrank = "📺 Вечное кабельное"
        addLog("ПРАНК: 'Вечное кабельное' - принудительное переключение на LiveTV...", colorHex: "#6C5CE7")
        
        let task = Task {
            for i in 1...4 {
                if Task.isCancelled { break }
                self.setInput("LiveTV (Канал \(i))")
                try? await Task.sleep(nanoseconds: 2_500_000_000)
            }
            if !Task.isCancelled {
                self.activePrank = nil
                self.addLog("ПРАНК: 'Вечное кабельное' завершен.", colorHex: "#00B894")
            }
        }
        prankTasks.append(task)
    }
    
    func prankPhantomMute() {
        stopAllPranks()
        activePrank = "🔇 Фантомный Mute"
        isMuted = true
        addLog("ПРАНК: 'Фантомный Mute' - звук приглушен на 3.5 секунды...", colorHex: "#E84393")
        
        let task = Task {
            try? await Task.sleep(nanoseconds: 3_500_000_000)
            if !Task.isCancelled {
                self.isMuted = false
                self.activePrank = nil
                self.addLog("ПРАНК: 'Фантомный Mute' завершен. Звук восстановлен.", colorHex: "#00B894")
            }
        }
        prankTasks.append(task)
    }
    
    func prankSoundWave() {
        stopAllPranks()
        activePrank = "🌊 Горки звука"
        originalVolume = volume
        addLog("ПРАНК: 'Горки звука' - разгон громкости до 36% и в ноль...", colorHex: "#0984E3")
        
        let task = Task {
            // Up to 36
            for v in stride(from: self.volume, through: 36, by: 4) {
                if Task.isCancelled { break }
                self.volume = v
                try? await Task.sleep(nanoseconds: 200_000_000)
            }
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            // Down to 0
            for v in stride(from: 36, through: 0, by: -5) {
                if Task.isCancelled { break }
                self.volume = max(0, v)
                try? await Task.sleep(nanoseconds: 200_000_000)
            }
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            if !Task.isCancelled {
                self.volume = self.originalVolume
                self.activePrank = nil
                self.addLog("ПРАНК: 'Горки звука' завершен. Громкость вернулась на \(self.originalVolume)%", colorHex: "#00B894")
            }
        }
        prankTasks.append(task)
    }
    
    func prankVolumeCreep() {
        stopAllPranks()
        activePrank = "📉 Сползание звука"
        originalVolume = volume
        addLog("ПРАНК: 'Сползание звука' - тихое пошаговое убавление громкости...", colorHex: "#A29BFE")
        
        let task = Task {
            for _ in 0..<5 {
                if Task.isCancelled { break }
                self.volume = max(0, self.volume - 1)
                try? await Task.sleep(nanoseconds: 1_200_000_000)
            }
            if !Task.isCancelled {
                self.activePrank = nil
                self.addLog("ПРАНК: 'Сползание звука' завершен.", colorHex: "#00B894")
            }
        }
        prankTasks.append(task)
    }
    
    func prankPoltergeist() {
        stopAllPranks()
        activePrank = "⏸ Полтергейст паузы"
        addLog("ПРАНК: 'Полтергейст паузы' - спам кнопкой паузы каждые 2.5 сек...", colorHex: "#FD79A8")
        
        let task = Task {
            for i in 1...4 {
                if Task.isCancelled { break }
                self.sendKey("PLAY_PAUSE")
                self.addLog("Полтергейст: нажата пауза (\(i)/4)...", colorHex: "#FD79A8")
                try? await Task.sleep(nanoseconds: 2_500_000_000)
            }
            if !Task.isCancelled {
                self.activePrank = nil
                self.addLog("ПРАНК: 'Полтергейст паузы' завершен.", colorHex: "#00B894")
            }
        }
        prankTasks.append(task)
    }
    
    func stopAllPranks() {
        prankTasks.forEach { $0.cancel() }
        prankTasks.removeAll()
        activePrank = nil
        isMuted = false
        isScreenOn = true
        addLog("🚨 ВСЕ ПРАНКИ ОСТАНОВЛЕНЫ. Состояние ТВ сброшено к норме.", colorHex: "#D63031")
    }
    
    // MARK: - CLI Interpreter
    
    func executeCommand(_ input: String) {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        addLog("> \(trimmed)", isCmd: true, colorHex: "#00CEC9")
        let parts = trimmed.components(separatedBy: " ")
        let cmd = parts[0].lowercased()
        let arg = parts.dropFirst().joined(separator: " ")
        
        switch cmd {
        case "help":
            addLog("Список команд HackBot CLI:", colorHex: "#6C5CE7")
            addLog("  help                - Показать эту справку", colorHex: "#8E9BB5")
            addLog("  status              - Телеметрия подключенного ТВ", colorHex: "#8E9BB5")
            addLog("  wol                 - Отправить Wake-on-LAN пакет", colorHex: "#8E9BB5")
            addLog("  power [on|off]      - Управление питанием", colorHex: "#8E9BB5")
            addLog("  screen [on|off]     - Управление подсветкой экрана", colorHex: "#8E9BB5")
            addLog("  vol [0..100]        - Установка громкости", colorHex: "#8E9BB5")
            addLog("  mute / unmute       - Переключение звука", colorHex: "#8E9BB5")
            addLog("  key [up|down|ok...] - Нажатие кнопки пульта", colorHex: "#8E9BB5")
            addLog("  input [hdmi1|live]  - Смена видеовхода", colorHex: "#8E9BB5")
            addLog("  yt [id]             - Открыть видео YouTube", colorHex: "#8E9BB5")
            addLog("  url [link]          - Открыть сайт в браузере", colorHex: "#8E9BB5")
            addLog("  prank [1..8]        - Запустить пранк по номеру", colorHex: "#8E9BB5")
            addLog("  stop                - Экстренный стоп всех пранков", colorHex: "#8E9BB5")
            addLog("  clear               - Очистить лог консоли", colorHex: "#8E9BB5")
            
        case "clear":
            terminalLogs.removeAll()
            addLog("Консоль очищена.", colorHex: "#8E9BB5")
            
        case "status":
            if let tv = currentTv, isConnected {
                addLog("TV: \(tv.name) [\(tv.ip)] | Питание: \(isPowerOn ? "ON" : "OFF") | Экран: \(isScreenOn ? "ON" : "OFF") | Громкость: \(volume)% | Пинг: \(pingLatency)ms", colorHex: "#00B894")
            } else {
                addLog("ТВ не подключен. Запустите 'scan' или выберите ТВ в меню.", colorHex: "#E17055")
            }
            
        case "wol":
            sendWoL()
            
        case "power":
            if arg.lowercased() == "off" {
                turnOffPower()
            } else {
                turnOnPower()
            }
            
        case "screen":
            if arg.lowercased() == "off" {
                setScreen(on: false)
            } else {
                setScreen(on: true)
            }
            
        case "vol", "volume":
            if let v = Int(arg) {
                setVolume(v)
            } else {
                addLog("Ошибка: укажите число от 0 до 100", colorHex: "#D63031")
            }
            
        case "mute":
            isMuted = true
            addLog("Звук заглушен (MUTE)", colorHex: "#E17055")
            
        case "unmute":
            isMuted = false
            addLog("Звук включен (UNMUTE)", colorHex: "#00B894")
            
        case "key":
            sendKey(arg.uppercased())
            
        case "input":
            setInput(arg.uppercased())
            
        case "yt", "youtube":
            openYouTube(videoIdOrUrl: arg)
            
        case "url", "browser":
            openBrowser(url: arg)
            
        case "prank":
            switch arg {
            case "1", "overheat": prankOverheat()
            case "2", "strobe": prankStrobe()
            case "3", "glitch": prankGlitch()
            case "4", "cable": prankCableLoop()
            case "5", "mute": prankPhantomMute()
            case "6", "wave": prankSoundWave()
            case "7", "creep": prankVolumeCreep()
            case "8", "pause": prankPoltergeist()
            default:
                addLog("Укажите номер пранка 1..8 (1: Overheat, 2: Strobe, 3: Glitch, 4: Cable, 5: Mute, 6: Wave, 7: Creep, 8: Pause)", colorHex: "#FDCB6E")
            }
            
        case "stop":
            stopAllPranks()
            
        default:
            addLog("Неизвестная команда: '\(cmd)'. Введите 'help' для списка.", colorHex: "#D63031")
        }
    }
    
    // MARK: - Wake-on-LAN Socket
    
    private func sendWakeOnLanPacket(mac: String) {
        let cleanMac = mac.replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: "-", with: "")
        
        guard cleanMac.count == 12 else { return }
        
        var macBytes = [UInt8]()
        for i in stride(from: 0, to: 12, by: 2) {
            let start = cleanMac.index(cleanMac.startIndex, offsetBy: i)
            let end = cleanMac.index(start, offsetBy: 2)
            if let byte = UInt8(cleanMac[start..<end], radix: 16) {
                macBytes.append(byte)
            }
        }
        guard macBytes.count == 6 else { return }
        
        var packet = [UInt8](repeating: 0xFF, count: 6)
        for _ in 0..<16 {
            packet.append(contentsOf: macBytes)
        }
        
        // Broadcast via NWConnection UDP
        let host = NWEndpoint.Host("255.255.255.255")
        let port = NWEndpoint.Port(integerLiteral: 9)
        let connection = NWConnection(host: host, port: port, using: .udp)
        
        connection.stateUpdateHandler = { state in
            if case .ready = state {
                connection.send(content: Data(packet), completion: .contentProcessed({ _ in
                    connection.cancel()
                }))
            }
        }
        connection.start(queue: .global())
    }
}
