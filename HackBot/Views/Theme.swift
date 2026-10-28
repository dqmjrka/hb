import SwiftUI

enum Theme {
    static let darkBg = Color(hex: "#0D0F17")
    static let cardBg = Color(hex: "#17192A")
    static let cardBorder = Color(hex: "#252A43")
    
    static let primaryPurple = Color(hex: "#6C5CE7")
    static let primaryPurpleLight = Color(hex: "#8A7CF0")
    
    static let accentGlow = Color(hex: "#00CEC9")
    static let accentPink = Color(hex: "#E84393")
    static let accentOrange = Color(hex: "#E17055")
    static let accentBlue = Color(hex: "#0984E3")
    
    static let statusGreen = Color(hex: "#00B894")
    static let statusRed = Color(hex: "#D63031")
    
    static let textPrimary = Color(hex: "#FFFFFF")
    static let textSecondary = Color(hex: "#8E9BB5")
    static let textDim = Color(hex: "#505A74")
}

extension Color {
    init(hex: String) {
        let cleanHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch cleanHex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue: Double(b) / 255.0,
            opacity: Double(a) / 255.0
        )
    }
}

struct CyberCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 16
    var borderColor: Color = Theme.cardBorder
    
    func body(content: Content) -> some View {
        content
            .background(Theme.cardBg)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
    }
}

extension View {
    func cyberCard(cornerRadius: CGFloat = 16, borderColor: Color = Theme.cardBorder) -> some View {
        self.modifier(CyberCardModifier(cornerRadius: cornerRadius, borderColor: borderColor))
    }
}
