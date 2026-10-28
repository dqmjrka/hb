import Foundation

struct TvDevice: Identifiable, Hashable, Equatable {
    let id: UUID
    var name: String
    var ip: String
    var mac: String
    var model: String
    var type: String
    var isOnline: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        ip: String,
        mac: String = "AA:BB:CC:DD:EE:FF",
        model: String = "Smart TV 4K",
        type: String = "LG WebOS",
        isOnline: Bool = true
    ) {
        self.id = id
        self.name = name
        self.ip = ip
        self.mac = mac
        self.model = model
        self.type = type
        self.isOnline = isOnline
    }
}

struct TerminalLine: Identifiable, Equatable {
    let id: UUID = UUID()
    let timestamp: String
    let text: String
    let isCommand: Bool
    let colorHex: String
}

enum PairingState: Equatable {
    case idle
    case connecting
    case promptSent
    case success
    case error(String)
}
